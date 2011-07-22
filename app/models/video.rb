class Video < ActiveRecord::Base
  belongs_to :teacher  
  has_many :video_views
  attr_accessible :name, :description, :type, :video_id, :teacher_id
  
  validates_presence_of :description
  
  def embed_code
    # if (location =~ /mov/) || (location =~ /mp4/)
    #       qt_embed_code
    #     elsif location =~ /flv/
    #       flv_embed_code
    #     else
    #       youtube_embed_code
    #     end
  end
  
end
