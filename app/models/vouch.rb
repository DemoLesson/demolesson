class Vouch < ActiveRecord::Base
  validates_presence_of :vouchee_id
  validates_presence_of :email

  has_many :vouched_skills
  has_many :skills_vouched_for

  belongs_to :vouchee, :class_name => 'User'
end
