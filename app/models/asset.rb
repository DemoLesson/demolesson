class Asset < ActiveRecord::Base
  belongs_to :teacher
  
  validates_presence_of :name, :file, :alert => 'You need to select a file to upload and enter the document name.'
  
  has_attached_file :file,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    :url  => '/assets/:basename.:extension',
                    :path => 'assets/:basename.:extension',
                    :bucket => 'DemoLessonS3', 
                    :processors => [:thumbnail, :timestamper],
                    :date_format => "%Y%m%d%H%M%S"
                    #add validation !!
end
