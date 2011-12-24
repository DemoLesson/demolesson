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
  
  has_many :experiences
  has_many :educations
  
  has_many :assets, :dependent => :destroy
  
  validates_associated :assets
  validates_uniqueness_of :url, :message => "The name you selected is not available."

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
  
  def self.owner_id(owner_id)
    @teacher = Teacher.find(owner_id)
    return @teacher.user_id
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