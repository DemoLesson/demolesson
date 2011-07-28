class TeachersController < ApplicationController
  before_filter :login_required
  layout :resolve_layout, :except => [:add_pin, :remove_pin, :add_star, :remove_star]

  # GET /teachers/1
  # GET /teachers/1.json
  def profile 
    @teacher = Teacher.find_by_url(params[:url])
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
    
    @pin = Pin.find(:first, :conditions => ['teacher_id = ? and user_id =?', @teacher.id, self.current_user.id], :limit => 1)
    @star = Star.find(:first, :conditions => ['teacher_id = ? and voter_id = ?', @teacher.id, self.current_user.id], :limit => 1)
    @stars = Star.find(:all, :conditions => ['teacher_id = ?', @teacher.id])
    
    @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'viddler.yml'))).result)[Rails.env]
    
    @video = Video.find_by_teacher_id(self.current_user.teacher.id, :limit => 1)
    if @video == nil
      @embed_code = @teacher.placeholder_embed_code
    else
      viddler = Viddler::Client.new(@config["api_token"])
      viddler.authenticate! @config["login"], @config["password"]
      begin
          video_info = viddler.get 'viddler.videos.getDetails', :video_id => @video.video_id
          @embed_code = @teacher.viddler_embed_code(video_info)
          return
      rescue Viddler::ApiException
          @embed_code = @teacher.error_embed_code
          puts "exception"
      end
    end
    
    if @teacher == nil
      redirect_to :root
      flash[:alert]  = "Not found"
    elsif @teacher.currently_seeking == true
      respond_to do |format|
        format.html # profile.html.erb
        #format.json  { render :json => @teacher }
      end
    else
      redirect_to :root
      flash[:notice] = "This teacher does not want their information to be publicly available at this time."
    end
  end
  
  def education
    @teacher = Teacher.find(self.current_user.teacher.id)
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
    
    
  end
  
  def experience
    @teacher = Teacher.find(self.current_user.teacher.id)
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
    
    
  end
  
  # GET /teachers/1
  # GET /teachers/1.json
  def show
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      if @teacher.url?
        format.html { redirect_to '/'+self.current_user.teacher.url }
      else
        format.html { redirect_to :create_profile }
      end
    end
  end
  
  def create_profile
    @teacher = Teacher.find(self.current_user.teacher.id)

    respond_to do |format|
      if @teacher.url?
        format.html { redirect_to '/'+self.current_user.teacher.url }
      else
        format.html # show.html.erb
        format.json  { render :json => @teacher }
      end
    end
    
  end

  # GET /teachers/new
  # GET /teachers/new.json
  def new
    @teacher = Teacher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @teacher }
    end
  end

  # GET /teachers/1/edit
  def edit
    @teacher = Teacher.find(params[:id])
    render :nothing => true, :status => "Forbidden" if @teacher.id != self.current_user.teacher.id
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(params[:teacher])
    @teacher.assets.build

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully created.') }
        format.json  { render :json => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teachers/1
  # PUT /teachers/1.json
  def update
    #params[:page][:existing_asset_attributes] ||= {}
    @teacher = Teacher.find(params[:id])
    flash[:error] = "Not authorized" and return unless @teacher.id == self.current_user.teacher.id

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # Attachments

  def attach
    @teacher = Teacher.find_by_id(self.current_user.teacher.id)
    @teacher.new_asset_attributes=params[:asset]

    respond_to do |format|
      if @teacher.save_assets
        format.html { redirect_to(:root, :notice => 'Attachment was successfully uploaded.') }
        format.json  { render :json => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def purge
    @asset = Asset.find_by_id(params[:id])
    if @asset.teacher_id = self.current_user.teacher.id
      @asset.destroy
    
      respond_to do |format|
       format.html { redirect_to(:root, :notice => 'Attachment removed.') }
       format.xml  { head :ok }
      end
    end
  end
  
  # Actions (AJAXify)
  
  def add_pin
    @pin = Pin.new
    @pin.user_id = self.current_user.id
    @pin.teacher_id = params[:teacher_id]
    
    # warning add duplicate check here
    
    if (request.xhr?)
      if @pin.save 
        render :text => "Pinned!"
      end
    else
        # No?  Then render an action.
        if @pin.save 
          respond_to do |format|
            format.html { redirect_to :root }
          end
        end
    end
  end
  
  def remove_pin
    @pin = Pin.find_by_teacher_id(params[:teacher_id], :limit => 1)
    @pin.destroy
    
    respond_to do |format|
      format.html { redirect_to :root }
    end
  end
  
  def add_star
    @star = Star.new
    @star.teacher_id = params[:teacher_id]
    @star.voter_id = self.current_user.id
    
    # warning add duplicate check here
    
    if @star.save 
      respond_to do |format|
        format.html { redirect_to :root }
      end
    end
  end
  
  def remove_star
    @star = Star.find(:first, :conditions => ['teacher_id = ? and voter_id = ?', params[:teacher_id], self.current_user.id], :limit => 1)
    @star.destroy
    
    respond_to do |format|
      format.html { redirect_to :root }
    end
  end
  
  private

  def resolve_layout
    case action_name
    when "profile"
      "standard"
    else
      "application"
    end
  end
end
