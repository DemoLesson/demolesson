class SchoolAdministrator < ActiveRecord::Base
  belongs_to :user
  belongs_to :school

  validates_presence_of :user
  validates_presence_of :school
end
