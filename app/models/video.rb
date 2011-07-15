class Video < ActiveRecord::Base
  belongs_to :teacher  
  has_many :video_views
  attr_accessible :name, :description, :type, :video_id, :teacher_id

#  validates_presence_of :teacher_id, :location

  def embed_code
    # if (location =~ /mov/) || (location =~ /mp4/)
    #       qt_embed_code
    #     elsif location =~ /flv/
    #       flv_embed_code
    #     else
    #       youtube_embed_code
    #     end
  end

  def flv_embed_code
#     string_to_embed = <<FLASH
# <div id="v#{id}">
# <a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this video.
# </div>
# <script type="text/javascript" src="https://media.dreamhost.com/mp4/swfobject.js"></script>
# <script type="text/javascript">
# var swf = new SWFObject("https://media.dreamhost.com/mp4/player.swf", "mpl", "640", "499", 8);
# swf.addParam("allowfullscreen", "true");
# swf.addParam("allowscriptaccess", "always");
# swf.addVariable("file", "http://video.demolesson.com/#{location}");
# swf.addVariable("image", "http://video.demolesson.com/#{location.gsub('flv','jpeg')}");
# swf.write("v#{id}");
# </script>
# FLASH
  end

  def youtube_embed_code
#     string_to_embed = <<YOUTUBE
# <iframe class="youtube-player" type="text/html" width="640" height="385" src="http://www.youtube.com/embed/#{location}" frameborder="0">
# </iframe>
# YOUTUBE
  end


  def qt_embed_code
#     string_to_embed = <<EMBED
# <OBJECT CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" WIDTH="352" HEIGHT="280" 
# CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab#version=6,0,2,0">
#       <PARAM NAME="controller" VALUE="TRUE">  
#       <PARAM NAME="type" VALUE="video/quicktime">
#       <PARAM NAME="autoplay" VALUE="TRUE">
#       <PARAM NAME="target" VALUE="myself">
#       <PARAM NAME="src" VALUE="streaming.demolesson.com/#{location}">
#       <PARAM NAME="HREF" VALUE="streaming.demolesson.com/#{location}">
#       <PARAM NAME="pluginspage" VALUE="http://www.apple.com/quicktime/download/indext.html">
#       <EMBED WIDTH="352" HEIGHT="280" AUTOPLAY="TRUE" CONTROLLER="TRUE" SRC="streaming.demolesson.com/#{location}" 
# HREF="streaming.demolesson.com/#{location}" type="video/quicktime" TARGET="myself" BGCOLOR="#000000" BORDER="0" 
# PLUGINSPAGE="http://www.apple.com/quicktime/download/indext.html"></EMBED></OBJECT>      
# EMBED
  end
  
end
