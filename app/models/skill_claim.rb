class SkillClaim < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :skill_id
  validates_presence_of :skill_group_id
end
