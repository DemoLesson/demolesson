class VouchedSkill < ActiveRecord::Base
  belongs_to :skill_group
  belongs_to :user
  belongs_to :vouch
end
