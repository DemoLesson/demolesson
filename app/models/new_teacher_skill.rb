class NewTeacherSkill < ActiveRecord::Base
  belongs_to :vouch
  belongs_to :skill_group
end
