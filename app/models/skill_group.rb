class SkillGroup < ActiveRecord::Base
  validates_presence_of :badge_url
  validates_presence_of :name

  has_many :skills, :dependent => :destroy
  has_many :skill_group_descriptions, :dependent => :destroy
end
