class VideosController < ApplicationController
  
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

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
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
    @video.teacher_id = self.current_user.teacher.id
    
    uploadHash = params[:video][:location]
    
    @viddler = Viddler::Base.new("5b17ds2ryeks1azgvt0l", "demolesson", "test123#")
    @new_video = @viddler.upload_video(:title => 'test file', :description => 'this is a test', :tags => 'demolesson', :file => File.open(uploadHash.tempfile), :make_public => 0)
    
    puts @new_video
    
    @video.video_id = @new_video.id
    
    @video.save
    
    # @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'vzaar.yml'))).result)[Rails.env]
    # 
    #     login = @config["login"]
    #     application_token = @config["application_token"]
    #     server_name = @config["server_name"]
    # 
    #     vzaar = Vzaar::Base.new :login => login, :application_token => application_token,
    #       :server => server_name
    #       
    #     uploadHash = params[:video][:location]
    #       
    #     vzaar.upload_video(uploadHash.tempfile, params[:name], params[:description], '1', 'false')

    #@signature = vzaar.signature
    #vzaar.upload_to_s3(@signature.acl, @signature.bucket, @signature.policy, @signature.aws_access_key, @signature.signature, @signature.key, uploadHash.tempfile)

    # respond_to do |format|
    #        if @video.save
    #          format.html { redirect_to(:root, :notice => 'Video was successfully created.') }
    #          format.xml  { render :xml => :root, :status => :created }
    #        else
    #          format.html { render :action => "new" }
    #          format.xml  { render :xml => :root, :status => :unprocessable_entity }
    #        end
    #     end
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
