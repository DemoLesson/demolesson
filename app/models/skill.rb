class Skill < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :skill_group_id
end
