class Video < ActiveRecord::Base
  belongs_to :teacher  
  has_many :video_views
  attr_accessible :name, :description, :type, :video_id, :teacher_id
  
  validates_presence_of :description
end
