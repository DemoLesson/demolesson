class Teacher < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :user
  attr_protected :user_id

  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects

  has_many :videos
  has_many :applications
  has_many :stars
  has_many :pins
  has_many :interviews
  
  has_many :experiences, :order => 'startYear DESC'
  has_many :educations, :order => 'current DESC, year DESC, start_year DESC'
  
  has_many :assets, :dependent => :destroy
  has_many :skills, :through => :user
  
  validates_associated :assets
  validates_uniqueness_of :url, :message => "The name you selected is not available."
  #validates_format_of :url, :with => /\w/, :message => "Invalid URL.", :unless => Teacher.new { |t| t.url.blank? }

  def self.find_or_create_from_user(user_id)
    original_user = User.find(user_id)
    if (original_user.present?)
      teacher = Teacher.find(:first, :conditions => {:user_id => user_id}) || Teacher.create!(:user_id => user_id)
      if (teacher.nil?)
        teacher = Teacher.create!(:user_id => user_id)
        teacher[:user_id] = user_id
        teacher.save
      end
    else
      teacher = nil
    end
    return(teacher)
  end

  def self.search(search)
    if search
      #check if search if an email or a name
      if search.include? "@"
        find(:all, :include => :user, :conditions => ['teachers.user_id = users.id && users.email LIKE ?', "%#{search}%"])
      else
        find(:all, :include => :user, :conditions => ['teachers.user_id = users.id && users.name LIKE ?', "%#{search}%"])
      end
    else
      find(:all)
    end
  end
  
  def self.owner_id(owner_id)
    @teacher = Teacher.find(owner_id)
    return @teacher.user_id
  end

  def vjs_embed_code(output_url)
    return "<video id=\"my_video_1\" class=\"video-js vjs-default-skin\" controls
		  preload=\"auto\" width=\"545\" height=\"429\"
		  data-setup=\"{}\"><source src=\"#{output_url}\" type='video/mp4'>
		</video>"
  end
  
  def no_embed_code
    return "<div align=\"center\" style=\"padding-top:200px\"><strong>This teacher has not yet uploaded a video, or it is processing.</strong></div>"
  end

  def snippet_watchvideo_button
    @video = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', self.id, true], :order => 'created_at DESC')
    if @video != nil
      embedstring= "<a rel=\"shadowbox;width=545;height=429;player=iframe\" href=\"/videos/#{@video.id.to_s}\" class='btn'>Watch Snippet</a>"

      begin
        if @video.encoded_state == 'queued'
          Zencoder.api_key = 'ebbcf62dc3d33b40a9ac99e623328583'
          @status = Zencoder::Job.progress(@video.job_id)
          if @status.body['outputs'][0]['state'] == 'finished'
            @video.encoded_state = 'finished'
            @video.save
            return embedstring
          else
            return ""
          end
        else 
          return embedstring
        end
      rescue
        return ""
      end
    else
      return ""
    end
  end

  def snippet_watchvideo_test
    @video = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', self.id, true], :order => 'created_at DESC')
    if @video != nil
      embedstring = "<a rel=\"shadowbox;width=545;height=429;player=iframe\" href=\"/videos/#{@video.id.to_s}\" class='btn'>Watch Snippet</a>"
    begin
      if @video.encoded_state == 'queued'
        Zencoder.api_key = 'ebbcf62dc3d33b40a9ac99e623328583'
        @status = Zencoder::Job.progress(@video.job_id)
        if @status.body['outputs'][0]['state'] == 'finished'
          @video.encoded_state = 'finished'
          @video.save
          return embedstring
        else
          if @status.body['outputs'][0]['state'] == 'failed'
            return "The snippet was unable to encode. Please check your start time." 
          else
            return "Processing..."
          end
        end
      else 
        return embedstring
      end
    rescue
      return "The snippet is currently doesn't exist or is encoding."
    end
    else
      return "You currently do not have a snippet."
    end
  end

  before_validation :update_video_embed, :if => lambda { |teacher| teacher.video_embed_url_changed? }  

  def update_video_embed
  	response = HTTParty.get "http://noembed.com/embed", { :query => { :url => self.video_embed_url } }
  	json = JSON.parse response.body

  	self.video_embed_html = json['html']
  end

  def vjs_test_embed
    @video = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', self.id, false], :order => 'created_at DESC')
    if @video != nil
      embedstring=   "<video id=\"my_video_1\" class=\"video-js vjs-default-skin\" controls
                  preload=\"auto\" width=\"545\" height=\"429\"
                  data-setup=\"{}\"><source src=\"#{@video.output_url}\" type='video/mp4'>
                </video>"
      begin
        if @video.encoded_state == 'queued'
          Zencoder.api_key = 'ebbcf62dc3d33b40a9ac99e623328583'
          @status = Zencoder::Job.progress(@video.job_id)
          if @status.body['outputs'][0]['state'] == 'finished'
            @video.encoded_state = 'finished'
            @video.save
            return embedstring
          else
            return "The video is currently encoding."
          end
        else 
          return embedstring
        end
      rescue
        return "Video is doesn't exist or is currently encoding."
      end
    else
      return "You currently do not have a video. Upload one now!"
    end
  end
  # Viddler API helpers
  
  def viddler_embed_code(video_info)
   return "<object width=\"545\" height=\"429\" id=\"viddlerOuter-386968dc\" type=\"application/x-shockwave-flash\" data=\"//www.viddler.com/mini/#{video_info}\"> <param name=\"movie\" value=\"//www.viddler.com/mini/#{video_info}\"> <param name=\"allowScriptAccess\" value=\"always\"><param name=\"allowNetworking\" value=\"all\"><param name=\"allowFullScreen\" value=\"true\"><param name=\"flashVars\" value=\"f=1&autoplay=f&disablebranding=1&loop=0&hd=0\"></object>"
  end
  
  def error_embed_code
    return "<div id=\"video_placeholder\">Video could not be loaded</div>"
  end
  
  def placeholder_embed_code
    return "<div id=\"video_placeholder\">This teacher doesn\'t have a video yet.</div>"
  end
  
  def create_guest_pass
      self.guest_code = rand(36**8).to_s(36)
  end
  
  ## Attached file methods
  
  def new_asset_attributes=(asset_attributes) 
    assets.build(asset_attributes)
    #asset_attributes.each do |attributes| 
    #  assets.build(attributes)
    #end 
  end
  
  def existing_asset_attributes=(asset_attributes) 
    assets.reject(&:new_record?).each do |asset| 
      attributes = asset_attributes[asset.id.to_s] 
      if attributes 
        asset.attributes = attributes 
      else 
        asset.delete(asset) 
      end 
    end
  end
  
  def save_assets 
    assets.each do |asset| 
      asset.save
    end
  end
  
end
