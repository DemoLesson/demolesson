require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :password, :within => 5..40
  #validates_presence_of :email, :password, :password_confirmation
  validates_confirmation_of :password
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email address."  

  has_many :school_administrators, :dependent => :destroy
  has_many :administered_schools, :through => :school_administrators, :source => :school

  has_many :activities, :order => 'created_at DESC'
  has_many :pins

  has_many :skill_claims, :dependent => :destroy
  has_many :skills, :through => :skill_claims

  has_many :skill_groups, :through => :skill_claims, :uniq => true
  has_many :skill_group_descriptions, :dependent => :destroy

  has_many :vouches_as_vouchee, :foreign_key => 'vouchee_id', :class_name => 'Vouch'
  has_many :vouches_as_voucher, :foreign_key => 'voucher_id', :class_name => 'Vouch'

  # Connecting to events
  has_many :events

  # Connect to analyic events
  has_many :analyics

  def vouches
    vouches_as_vouchee + vouches_as_voucher
  end
  
  # People who vouch for me
  def vouchers
    vouches_as_vouchee.map { |v| v.voucher }
  end

  # People who I vouch for
  def vouchees
    vouches_as_voucher.map { |v| v.vouchee }
  end
  
  has_many :owners, :class_name => 'SharedUsers', :foreign_key => :user_id, :dependent => :destroy
  has_many :reverse_owners, :class_name => 'SharedUsers', :foreign_key => :owner_id, :dependent => :destroy

  has_many :managed_users, :through => :owners, :source => :owner
  
  attr_protected :id, :salt, :is_admin, :verified
  attr_accessor :password, :password_confirmation
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :avatar #, :login_count, :last_login

  before_create :set_full_name
  after_create :send_verification_email

  has_one :teacher
  has_many :videos, :through => :teacher
  has_many :applications, :through => :teacher
  has_many :connections, :foreign_key => "owned_by", :conditions => "pending = false", :dependent => :destroy
  has_many(:pending_connections,
           :class_name => 'Connection',
           :foreign_key => "user_id",
           :conditions => "pending = true",
           :dependent => :destroy)
  
  has_one :login_token
  
  has_attached_file :avatar,
                    :styles => { :medium => "201x201>", :thumb => "100x100", :tiny => "45x45" },
                    :storage => :s3,
                    :content_type => [ 'image/jpeg', 'image/png' ],
                    :s3_credentials => Rails.root.to_s+"/config/s3.yml",
                    :url  => '/avatars/:style/:basename.:extension',
                    :path => 'avatars/:style/:basename.:extension',
                    :bucket => 'DemoLessonS3',
                    :processors => [:thumbnail, :timestamper],
                    :date_format => "%Y%m%d%H%M%S"
  
  #validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, :content_type => [/^image\/(?:jpeg|gif|png)$/, nil], :message => 'Uploading picture failed.'  
  # WARNING                                 
  #validates_attachment_size :avatar, :less_than => 2.megabytes,
  #                                   :message => 'Picture was too large, try scaling it down.'


  #soft deletion
  default_scope where(:deleted_at => nil)

  def is_admin?
    self.school != nil || self.is_shared == true
  end

  def is_limited?
    self.is_limited
  end

  def all_schools
    if self.is_limited?
      return self.sharedschools
    else
      return self.schools
    end
  end

  def all_jobs_for_schools
    all_schools.each.inject([]) do |jobs, school|
      jobs += Job.find(:all,
                       :conditions => ['school_id = ? AND active = ?', school.id, true],
                       :order => 'created_at DESC')
    end
  end
  
  def create_teacher

    # Set the teacher to a shorter variable
    t = self.teacher

    # If there is already a teacher model connected
    # then don't create a new teacher
    if t.nil?
      t = Teacher.create!(:user => self)
      t.user_id = self.id
      t.create_guest_pass
      t.save!
    end

    # Return
    return t

    # Nothing from here to "end" is being run
    @mailer = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'mailer.yml'))).result)[Rails.env]
    @message = Message.new
    @message.user_id_from = @mailer["from"].to_i
    @message.user_id_to = self.id
    @message.subject = @mailer["subject"]
    @message.body = "Hi "+self.name+","+@mailer["message"]+"Brian Martinez"
    @message.read = false
    @message.save
  end
  
  # def create_additional_school
  #     s = School.create!(:user => self, :map_address => '100 West 1st Street', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :name => 'New School', :gmaps => 1)
  #     s.owned_by = self.id
  #     s.save!
  #     return s
  #   end

  def create_school
    s = self.school
    if s.nil?
      s = School.create!(:user => self, :map_address => '100 W 1st St', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :name => 'New School', :gmaps => 1)
      s.owned_by = self.id
      s.save!
    end
    return s
    @mailer = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'mailer_schools.yml'))).result)[Rails.env]
    @message = Message.new
    @message.user_id_from = @mailer["from"].to_i
    @message.user_id_to = self.id
    @message.subject = @mailer["subject"]
    @message.body = "Hi "+self.name+","+@mailer["message"]+"Brian Martinez"
    @message.read = false
    @message.activify
    @message.save
  end

  def teacher
    return(Teacher.find(:first, :conditions => {:user_id => id}))
  end

  def school
    return(School.find(:first, :conditions => {:owned_by => id}))
  end

  def job_allowance
    if is_shared
      @shared= SharedUsers.find(:first, :conditions => { :user_id => id})
      o=Organization.find(:first, :conditions => { :owned_by => @shared.owned_by})
      return(o.job_allowance)
    else
      o=Organization.find(:first, :conditions => { :owned_by => id})
      return(o.job_allowance)
    end
  end
  
  def schools
    if is_shared
      s=SharedUsers.find(:first, :conditions => {:user_id => id})
      return(School.find(:all, :conditions => {:owned_by => s.owned_by}))
    else
      return(School.find(:all, :conditions => {:owned_by => id}))
    end
  end

  def jobcount
    jobs=0
    schools=self.schools
    schools.each do |school|
      jobs=school.jobs.count+jobs
    end
    return(jobs)
  end
  
  def sharedschool
    if is_limited == true
      school = SharedSchool.find(:first, :conditions => { :user_id => id } )
      return(School.find(school.school_id))
    else
      admin= SharedUsers.find(:first, :conditions => { :user_id => id})
      return(School.find(:first, :conditions => {:owned_by => admin.owned_by}))
    end
  end

  def sharedschools
    schools = SharedSchool.find(:all, :conditions => { :user_id => id }).collect(&:school_id)
    return(School.find(schools))
  end

  def organization
    if is_shared
      s=SharedUsers.find(:first, :conditions => { :user_id => id })
      return(Organization.find(:first, :conditions => { :owned_by => s.owned_by }))
    else
      return(Organization.find(:first, :conditions => { :owned_by => id }))
    end
  end

  def self.authenticate(email, pass)
    user = find(:first, :conditions=>["email = ?", email])

    if user.nil? or User.encrypt(pass, user.salt) != user.hashed_password
      return nil
    end

    user
  end
  
  def update_login_count
    puts "logincount update"
    
    u=User.find(self.id)
    if u.login_count?
      u.login_count = u.login_count+1
    else
      u.login_count = 1
    end
    u.update_attribute(:last_login, Time.now)
  end
  
  def send_verification_email
    self.verification_code = User.random_string(10)
      self.save!
      #Notifications.deliver_verification(self.id, self.name, self.verification_code)
  end
  
  def self.verify!(user_id, verification_code)
    u=find(user_id)
    if (u.present? && u.verification_code == verification_code)
      u.is_verified = true
      u.save!(false)
    else
      raise "verification code does not match email or unregistered email"
    end
  end
    
  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save!
    UserMailer.deliver_forgot_password(self.email, self.name, new_pass).deliver
    #Notifications.deliver_forgot_password(self.email, self.name, new_pass)
  end

  def set_full_name
    logger.debug "!!! SET FULL NAME !!!"
    self.name = "#{first_name} #{last_name}"
  end
  
  def update_settings(params)
    @user = User.find(self.id)
  
    if User.authenticate(@user.email, params[:password]) == @user
      # self.password = params[:password]
      self.email = params[:email]
      self.name = params[:name]
      self.password = self.password_confirmation = params[:password]
      
      #if self.update_attributes(:email => params[:email], :name => params[:name], :password => params[:password])
      if self.save!
        return "Your settings have been updated!"
      else
        return "Could not update your settings."
      end
    else
      return "Your password was incorrect."
    end
  end
  
  def change_password(params)
    @user = User.find(self.id)
    
    if User.authenticate(self.email, params[:current_password]) == @user 
      new_pass = params[:password]
      confirm_pass = params[:confirm_password]

      if new_pass == confirm_pass
        self.password=new_pass
        if self.save
          return "Successfully changed your password."
        else
          return "Could not change your password."
        end
      end        
    else
      return "Your current password was incorrect." 
    end
  end

  def cleanup
    @schools = School.find(:all, :conditions => ['owned_by = ?', self.id])
    @schools.each do |school|
      school.remove_associated_data
    end
    @schools.map(&:destroy)
    @teachers = Teacher.find(:all, :conditions => ['user_id = ?', self.id])
    @teachers.map(&:destroy)
    @sharedusers=SharedUsers.find(:all, :conditions => ['user_id = ?', self.id])
    @sharedusers.map(&:destroy)
    @sharedschools=SharedSchool.find(:all,:conditions => ['user_id = ?', self.id])
    @sharedschools.map(&:destroy)
    @applications = Application.find(:all, :conditions => ['teacher_id = ?', self.id])
    @applications.each do |application|
      @activities = Activity.find(:all, :conditions => ['application_id = ?', application.id])
      @activities.map(&:destroy)
    end
    @applications.map(&:destroy)
  end
  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
 
