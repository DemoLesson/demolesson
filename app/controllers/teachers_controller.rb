class TeachersController < ApplicationController
  before_filter :login_required, :except => [:profile, :guest_entry]
  layout :resolve_layout, :except => [:add_pin, :remove_pin, :add_star, :remove_star]

  # GET /teachers/1
  # GET /teachers/1.json
  def profile 
    @teacher = Teacher.find_by_url(params[:url])
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
    
    guest_pass = params[:guest_pass]

    if self.current_user == nil 
      redirect_to :root if guest_pass.to_s != @teacher.guest_code
    end
    
    puts guest_pass.to_s == @teacher.guest_code
    
    if self.current_user != nil
      @pin = Pin.find(:first, :conditions => ['teacher_id = ? and user_id =?', @teacher.id, self.current_user.id], :limit => 1)
      @star = Star.find(:first, :conditions => ['teacher_id = ? and voter_id = ?', @teacher.id, self.current_user.id], :limit => 1)
    end
    
    @stars = Star.find(:all, :conditions => ['teacher_id = ?', @teacher.id])
    
    @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'viddler.yml'))).result)[Rails.env]
    
    @video = Video.find(:all, :conditions => ['teacher_id = ?', @teacher.id], :order => 'created_at DESC')
    @video = @video.first
    
    begin
      if @video.encoded_state == 'queued'
        Zencoder.api_key = 'ebbcf62dc3d33b40a9ac99e623328583'
        @status = Zencoder::Job.progress(@video.job_id)
        if @status.body['outputs'][0]['state'] == 'finished'
          @video.encoded_state = 'finished'
          @video.save
          @embed_code = @teacher.vjs_embed_code(@video.output_url)
        else
          @embed_code = @teacher.no_embed_code
        end
      else 
        @embed_code = @teacher.vjs_embed_code(@video.output_url)
      end
    rescue
      @embed_code = @teacher.no_embed_code
    end
    
    if @teacher == nil
      redirect_to :root
      flash[:alert]  = "Not found"
    elsif @teacher.currently_seeking == true
      respond_to do |format|
          format.html # profile.html.erb
          format.json  { render :json => @teacher } # profile.json
      end
    else
      if self.current_user.teacher.id == @teacher.id
        respond_to do |format|
          format.html
        end
      else
        redirect_to :root
        flash[:notice] = "This teacher does not want their information to be publicly available at this time."
      end
    end
  end
  
  # Guest pass
  
  def guest_entry
    guest_pass = params[:guest_pass]
    
    @teacher = Teacher.find_by_guest_code(guest_pass)
    redirect_to '/'+@teacher.url+'/'+guest_pass
  end
  
  # Profile Editing
  
  def education
    @teacher = Teacher.find(self.current_user.teacher.id)
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
  end
  
  def remove_education
    @education = Education.find_by_id(params[:id], :limit => 1)
    @education.destroy
    
    respond_to do |format|
      format.html { redirect_to :education }
    end
  end
  
  def edit_education
    @education = Education.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def update_education
    @teacher = Teacher.find(self.current_user.teacher.id)
    @teacher.educations.build(params[:education])
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to :education, :notice => "Education details updated." }
      else
        format.html { redirect_to :education, :notice => "An error occurred."}
      end 
    end
  end
  
  def update_existing_education
    @education = Education.find(params[:id])
    
    respond_to do |format|
      if @education.update_attributes(params[:education])
        format.html { redirect_to :education, :notice => "Education details updated." }
      else
        format.html { redirect_to :education, :notice => "An error occurred."}
      end 
    end
  end
  
  def experience
    @teacher = Teacher.find(self.current_user.teacher.id)
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?
  end
  
  def remove_experience
    @experience = Experience.find_by_id(params[:id], :limit => 1)
    @experience.destroy
    
    respond_to do |format|
      format.html { redirect_to :experience }
    end
  end
  
  def edit_experience
    @experience = Experience.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def update_experience
    @teacher = Teacher.find(self.current_user.teacher.id)
    @teacher.experiences.build(params[:experience])
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to :experience, :notice => "Experience details updated." }
      else
        format.html { redirect_to :experience, :notice => "An error occurred."}
      end 
    end
  end
  
  def update_existing_experience
    @experience = Experience.find(params[:id])
    
    respond_to do |format|
      if @experience.update_attributes(params[:experience])
        format.html { redirect_to :experience, :notice => "Experience details updated." }
      else
        format.html { redirect_to :experience, :notice => "An error occurred."}
      end 
    end
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
    
    #REFACTOR : all editing pages should have a header/button row
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
    #@teacher.url = params[:teacher][:url]
    #@teacher.url = @teacher.url.gsub(/\w/)
    #@teacher.save

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
  #REFACTOR

  def attach
    @teacher = Teacher.find_by_id(self.current_user.teacher.id)
    @teacher.new_asset_attributes=params[:asset]

    respond_to do |format|
      if @teacher.save_assets
        format.html { redirect_to(@teacher, :notice => 'Attachment was successfully uploaded.') }
        format.json  { render :json => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def purge
    @teacher = Teacher.find_by_id(self.current_user.teacher.id)
    @asset = Asset.find_by_id(params[:id])
    if @asset.teacher_id == self.current_user.teacher.id
      @asset.destroy
    
      respond_to do |format|
       format.html { redirect_to(@teacher, :notice => 'Attachment removed.') }
       format.xml  { head :ok }
      end
    end
  end
  
  # Actions (AJAXify + REFACTOR)
  
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
