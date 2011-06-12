class Job < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects
  
  has_many :applications
  has_many :winks
end
