class Video < ActiveRecord::Base
  belongs_to :teacher
  has_many :video_views
  attr_accessible :name, :description, :type, :video_id, :teacher_id
  
  #validates_presence_of :description
  mount_uploader :video, VideoUploader
  
  scope :finished, :conditions => { :encoded_state => "finished" }

  #has_attached_file :attached_video,
  #  :url => ":class/:id/:style/:basename.:extension",
  #  :path => ":class/:id/:style/:basename.:extension",
  #  :storage => :s3,
  #  :s3_credentials => "#{Rails.root}/config/amazon_s3.yml"
  #validates_attachment_presence :attached_video
  
  has_attached_file :thumbnail, :styles => {:thumb => "162x161>"}

  #after_destroy :remove_encoded_video
  
  # https://github.com/zencoder/zencoder-rb

  # commence encoding of the video.  Width and height are hard-coded into this, but there may be situations where
  # you want that to be more dynamic - that modification will be trivial.
  def encode!(options = {})
    begin
      zen = Zencoder::Job.create({:api_key => 'ebbcf62dc3d33b40a9ac99e623328583', :input => "s3://DemoLessonVideo/" + self.secret_url, :outputs => [{:label => self.name, :url => 's3://DLEncodedVideo/' + self.id.to_s }]})
      puts zen
      
      #zen = Zencoder.new("http://s3.amazonaws.com/" + zencoder_setting["s3_output"]["bucket"], zencoder_setting["settings"]["notification_url"])
      # 'video.url(:original, false)' prevents paperclip from adding timestamp, which causes errors
      #if zen.encode(self.video.url(:original, false), 800, 450, "/thumbnails_#{self.id}", options)
        self.encoded_state = "queued"
        self.output_url = zen.body['id']
        puts zen.body
        #self.job_id = zen.job_id
        self.save!
      #else
      #  errors.add_to_base(zen.errors)
      #  nil
      #end
    rescue RuntimeError => exception
      errors.add_to_base("Video encoding request failed with result: " + exception.to_s)
      nil
    end
  end

  # this runs on the after_destroy callback.  It is reponsible for removing the encoded file
  # and the thumbnail that is associated with this video.  Paperclip will automatically remove the other files, but
  # since we created our own bucket for encoded video, we need to handle this part ourselves.
  def remove_encoded_video
    unless output_url.blank?
      AWS::S3::Base.establish_connection!(
        :access_key_id     => zencoder_setting["s3_output"]["access_key_id"],
        :secret_access_key => zencoder_setting["s3_output"]["secret_access_key"]
      )
      AWS::S3::S3Object.delete(File.basename(output_url), zencoder_setting["s3_output"]["bucket"])
      # there is no real concept of folders in S3, they are just labels, essentially
      AWS::S3::S3Object.delete("/thumbnails_#{self.id}/frame_0000.png", zencoder_setting["s3_output"]["bucket"])
    end
  end
  
  # must be called from a controller action, in this case, videos/encode_notify, that will capture the post params
  # and send them in.  This captures a successful encoding and sets the encode_state to "finished", so that our application
  # knows we're good to go.  It also retrieves the thumbnail image that Zencoder creates and attaches it to the video
  # using Paperclip.  And finally, it retrieves the duration of the video, again from Zencoder.
  def capture_notification(output)
    self.encoded_state = output[:state]
    if self.encoded_state == "finished"
      self.output_url = output[:url]
      self.thumbnail = open(URI.parse("http://s3.amazonaws.com/" + zencoder_setting["s3_output"]["bucket"] + "/thumbnails_#{self.id}/frame_0000.png"))
      self.thumbnail_content_type = "image/png"
      # get the job details so we can retrieve the length of the video in milliseconds
      zen = Zencoder.new
      self.duration_in_ms = zen.details(self.job_id)["job"]["output_media_files"].first["duration_in_ms"]
    end
    self.save
  end

  # a handy way to turn duration_in_ms into a formatted string like 5:34
  def human_length
    if duration_in_ms
      minutes = duration_in_ms / 1000 / 60
      seconds = (duration_in_ms / 1000) - (minutes * 60)
      sprintf("%d:%02d", minutes, seconds)
    else
      "Unknown"
    end
  end

  private

  def zencoder_setting
    @zencoder_config ||= YAML.load_file("#{Rails.root}/config/zencoder.yml")
  end
  
  def video_changed?
    return false
  end
    
end
