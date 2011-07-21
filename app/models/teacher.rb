class Teacher < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :user
  attr_protected :user_id

  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects

  has_many :videos
  has_many :applications
  has_many :winks
  
  has_attached_file :resume, 
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    :url  => '/resumes/:basename.:extension',
                    :path => 'resumes/:basename.:extension',
                    :bucket => 'DemoLessonS3'
                    
                    #add validation !!

  def self.find_or_create_from_user(user_id)
    original_user = User.find(user_id)
    if (original_user.present?)
      teacher = Teacher.find(:first, :conditions => {:user_id => user_id}) || Teacher.create!(:user_id => user_id)
      if (teacher.nil?)
        teacher = Teacher.create!(:user_id => user_id)
        teacher[:user_id] = user_id
        teacher.save
      end
    else
      teacher = nil
    end
    return(teacher)
  end
end
