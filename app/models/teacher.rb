class Teacher < ActiveRecord::Base
  belongs_to :user
  attr_protected :user_id

  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects

  has_many :videos
  has_many :applications
  has_many :winks

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
