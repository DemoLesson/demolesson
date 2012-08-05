class Skill < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :skill_group_id

  has_many :skill_claims, :dependent => :destroy
  belongs_to :skill_group
end
