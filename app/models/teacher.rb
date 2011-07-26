class Teacher < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :user
  attr_protected :user_id

  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects

  has_many :videos
  has_many :applications
  has_many :winks
  
  has_many :assets, :dependent => :destroy
  
  validates_associated :assets
  
  #after_update :save_assets
  
  # has_attached_file :resume, 
  #                   :storage => :s3,
  #                   :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
  #                   :url  => '/resumes/:basename.:extension',
  #                   :path => 'resumes/:basename.:extension',
  #                   :bucket => 'DemoLessonS3'

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
  
  ## Viddler API helpers
  
  def viddler_embed_code(video_info)
    return "<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"545\" height=\"429\" id=\"viddler_82e4a107\"><param name=\"movie\" value=\"http://www.viddler.com/simple/#{video_info["video"]["id"]}/\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowFullScreen\" value=\"true\" /><embed src=\"http://www.viddler.com/simple/#{video_info["video"]["id"]}/\" width=\"545\" height=\"429\" type=\"application/x-shockwave-flash\" allowScriptAccess=\"always\" allowFullScreen=\"true\" name=\"viddler_#{video_info["video"]["id"]}\"></embed></object>"
  end
  
  def error_embed_code
    return "<div id=\"video_placeholder\">Video could not be loaded</div>"
  end
  
  def placeholder_embed_code
    return "<div id=\"video_placeholder\">This teacher doesn\'t have a video yet.</div>"
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