class VideosController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => [:encode_notify]
  layout nil
  layout 'application', :except => :show
  #REFACTOR
  # GET /videos
  # GET /videos.xml
  def index
    @videodb = Video.all
    
    @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'viddler.yml'))).result)[Rails.env]
    
    viddler = Viddler::Client.new(@config["api_token"])
    viddler.authenticate! @config["login"], @config["password"]
    
    @videos = viddler.get 'viddler.videos.getByUser', :user => @config["login"]
    puts @videos
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videodb }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end
  
  def myvideo
    @teacher = self.current_user.teacher
    if Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC').nil?
      @has_video = false
    else
      @has_video = true
    end
    
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @teacher = self.current_user.teacher
    if Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC').nil?
      @has_video = false
    else
      @has_video = true
    end
    @video = Video.new
    
    @uploader = Video.new.video
    @uploader.success_action_redirect = new_video_url
    
    if params[:key]
      @video.teacher_id = self.current_user.teacher.id
      @video.secret_url = params[:key]
      @video.video_id = params[:etag]
    end

    respond_to do |format|
      if params[:key]
        if @video.save
          @video.encode
          format.html { redirect_to :back, :notice => "Your video was succesfully uploaded and is processing." }
        end
      else
        format.html # new.html.erb
        format.xml  { render :xml => @video }
      end
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])
    
    payload = params[:video][:location]
    #File.open(payload.tempfile)
    
    @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 's3.yml'))).result)[Rails.env]
    
    AWS::S3::Base.establish_connection!(
       :access_key_id     => @config["access_key_id"],
       :secret_access_key => @config["secret_access_key"]
    )
    
    AWS::S3::S3Object.store(payload.original_filename, open(payload.tempfile), 'DemoLessonVideo', :access => :public_read)
    
    respond_to do |format|
       if @video.save
         @video.encode
         format.html { redirect_to(:root, :notice => 'Video was successfully uploaded.') }
         format.xml  { render :xml => @video, :status => :created }
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => :root, :status => :unprocessable_entity }
       end
    end
  end
  
  def update_details
    
    respond_to do |format|
      if @video.save
        format.html { redirect_to(:root, :notice => 'Video was successfully uploaded.')}
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to(@video, :notice => 'Video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_snippet
    @timestring = params[:date][:hour].to_s+":"+params[:date][:minute].to_s+":"+params[:date][:second].to_s+".0"
    @video = Video.new
    @video.teacher_id = self.current_user.teacher.id
    @teacher = self.current_user.teacher
    @sourcevideo = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC')
    @video.secret_url = @sourcevideo.secret_url
    @video.video_id = @sourcevideo.video_id
    @video.is_snippet = true
    respond_to do |format|
      if @video.save
        @video.snippet_encode(@timestring)
        format.html { redirect_to :back, :notice => "Your snippet has been created and is currently encoding." }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end
end
