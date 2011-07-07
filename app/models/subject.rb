class Subject < ActiveRecord::Base
  attr_accessible :name, :description
  
  belongs_to :teacher
  belongs_to :subject  
end
