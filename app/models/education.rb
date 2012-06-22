class Education < ActiveRecord::Base
  belongs_to :teacher
  
  validates_presence_of :school, :degree, :concentrations
end
