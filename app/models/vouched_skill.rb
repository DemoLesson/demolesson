class VouchedSkill < ActiveRecord::Base
  belongs_to :vouch
  belongs_to :user
  belongs_to :skill
end
