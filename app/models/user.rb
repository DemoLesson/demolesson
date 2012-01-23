require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :password, :within => 5..40
  #validates_presence_of :email, :password, :password_confirmation
  validates_confirmation_of :password
  validates_presence_of :name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email address."  

  attr_protected :id, :salt, :is_admin, :verified
  attr_accessor :password, :password_confirmation
  attr_accessible :name, :email, :password, :password_confirmation, :avatar#, :login_count, :last_login
  
  after_create :send_verification_email

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

  def create_teacher
    t = self.teacher
    if t.nil?
      t = Teacher.create!(:user => self)
      t.user_id = self.id
      t.create_guest_pass
      t.save!
    end
    return t
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
      s = School.create!(:user => self, :map_address => '100 West 1st Street', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :name => 'New School', :gmaps => 1)
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
  
  def schools
    return(School.find(:all, :conditions => {:owned_by => id}))
  end

  def self.authenticate(email, pass)
    u=find(:first, :conditions=>["email = ?", email])
    #	logger.info("found user #{u.inspect}")
    return nil if u.nil?
    #	logger.info("seeing if #{User.encrypt(pass, u.salt)}==#{u.hashed_password}")
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
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
    Notifications.deliver_forgot_password(self.email, self.name, new_pass)
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
