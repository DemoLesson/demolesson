class TeachersController < ApplicationController
  before_filter :login_required, :except => [:profile, :guest_entry]
  layout :resolve_layout, :except => [:add_pin, :remove_pin, :add_star, :remove_star]
  API_KEY, SECRET_KEY = "mgb6uz10qf31", "9WXAkgt6TyPdfJGI"

  # GET /teachers/1
  # GET /teachers/1.json
  def profile 
    @teacher = Teacher.find_by_url(params[:url])
    raise ActiveRecord::RecordNotFound, "Teacher not found." if @teacher.nil?

    @application = nil
    if params[:application] != nil
      @application = Application.find(params[:application])
      if @application.belongs_to_me(self.current_user)
      else
        @application = nil
      end
    end
    
    guest_pass = params[:guest_pass]

    if self.current_user == nil 
      redirect_to :root if guest_pass.to_s != @teacher.guest_code
    end
    
    puts guest_pass.to_s == @teacher.guest_code
    
    if self.current_user != nil
      @pin = Pin.find(:first, :conditions => ['teacher_id = ? and user_id =?', @teacher.id, self.current_user.id], :limit => 1)
      @star = Star.find(:first, :conditions => ['teacher_id = ? and voter_id = ?', @teacher.id, self.current_user.id], :limit => 1)
      @connection = Connection.find(:first, :conditions => ['owned_by = ? and user_id = ?', self.current_user.id, @teacher.user.id])
      @pendingconnection =  Connection.find(:first, :conditions => ['owned_by = ? and user_id = ? and pending = true', @teacher.user.id, self.current_user.id])
    end

    @stars = Star.find(:all, :conditions => ['teacher_id = ?', @teacher.id])
    
    @config = YAML::load(ERB.new(IO.read(File.join(Rails.root.to_s, 'config', 'viddler.yml'))).result)[Rails.env]
    
    @video = Video.find(:all, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC')
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
    else @teacher.currently_seeking == true
      respond_to do |format|
        format.html # profile.html.erb
        format.json  { render :json => @teacher } # profile.json
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
    
    @experience = Experience.new(params[:experience])
    @experience.startMonth = params[:date][:startMonth]
    @experience.startYear = params[:date][:startYear]
    @experience.endMonth = params[:date][:endMonth]
    @experience.endYear = params[:date][:endYear]
    
    @teacher.experiences.build(:company => @experience.company, :position => @experience.position, :description => @experience.description, :startMonth => @experience.startMonth, :startYear => @experience.startYear, :endMonth => @experience.endMonth, :endYear => @experience.endYear)
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to :experience, :notice => "Experience details updated." }
      else
        format.html { redirect_to :experience, :notice => "An error occurred."}
      end 
    end
  end
  
  def update_existing_experience
    @prev_experience = Experience.find(params[:id])
    
    @experience = Experience.new(params[:experience])
    @experience.startMonth = params[:date][:startMonth]
    @experience.startYear = params[:date][:startYear]
    @experience.endMonth = params[:date][:endMonth]
    @experience.endYear = params[:date][:endYear]
    
    respond_to do |format|
      if @prev_experience.update_attributes(:company => @experience.company, :position => @experience.position, :description => @experience.description, :startMonth => @experience.startMonth, :startYear => @experience.startYear, :endMonth => @experience.endMonth, :endYear => @experience.endYear)
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
       format.html { redirect_to(:back, :notice => 'Attachment removed.') }
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
    
    @teacher = Teacher.find(params[:teacher_id])
    
    if @star.save
      respond_to do |format|
        format.html { redirect_to "/"+@teacher.url }
      end
    end
  end
  
  def remove_star
    @star = Star.find(:first, :conditions => ['teacher_id = ? and voter_id = ?', params[:teacher_id], self.current_user.id], :limit => 1)
    @star.destroy
    
    @teacher = Teacher.find(params[:teacher_id])
    
    respond_to do |format|
      format.html { redirect_to "/"+@teacher.url }
    end
  end

  def linkedinprofile
    if request.post?
      if params[:response] == 'yes'
        client = LinkedIn::Client.new(API_KEY, SECRET_KEY)
        #oauth_Callback=where linkedin will redirect back to
        request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/callback")
        session[:rtoken] = request_token.token
        session[:rsecret] = request_token.secret
        redirect_to client.request_token.authorize_url
      elsif params[:response] == 'no'
        redirect_to '/'+self.current_user.teacher.url     
      end
    end
  end

  def callback
    @teacher = Teacher.find(self.current_user.teacher.id)
    client = LinkedIn::Client.new(API_KEY, SECRET_KEY)
    pin = params[:oauth_verifier]
    client.authorize_from_request(session[:rtoken], session[:rsecret], pin)

    #begin populating profile
    #set teacher.linkedin
    user = client.profile(:fields => %w(public-profile-url))
    @teacher.update_attribute(:linkedin, user.public_profile_url)

    #educations
    user = client.profile(:fields => %w(educations))
    if user.educations.all != nil
      user.educations.all.each do |education|
        school = education.school_name
        degree = education.degree
        concentrations = education.field_of_study
        year = education.end_date.year
        @teacher.educations.build(:school => school, :degree => degree, :concentrations => concentrations, :year => year)
        @teacher.save
      end
    end

    #positions
    user = client.profile(:fields => %w(positions))
    currentposition=nil
    currentschool=nil
    if user.positions.all != nil
      user.positions.all.each do |position|
        company = position.company.name
        positiontitle = position.title
        startMonth = position.start_date.month
        startYear = position.start_date.year
        if position.is_current == true
          endMonth = Time.now.month
          endYear = Time.now.year
          current = true
          if position.company.industry == "Primary/Secondary Education"
            currentposition = position.title
            currentschool = position.company.name
          end
        else
          endMonth = position.end_date.month
          endYear = position.end_date.year
          current = false
        end
        @teacher.experiences.build(:company => company, :position => positiontitle, :startMonth => startMonth, :startYear => startYear, :endMonth => endMonth, :endYear => endYear, :current => current)
        @teacher.save
      end
    end
    if currentschool != nil && currentposition != nil
      @teacher.update_attribute(:school, currentschool)
      @teacher.update_attribute(:position, currentposition)
    end

    #phone number
    user= client.profile(:fields => %w(phone-numbers))
    phone=nil
    if user.phone_numbers.all != nil
      user.phone_numbers.all.each do |number|
        if number.phone_type == "home" || number.phone_type == "mobile"
          phone = number.phone_number
          break
        end
      end
    end
    if phone != nil
      @teacher.update_attribute(:phone, phone)
    end

    #Addtional Information:
    addinfo = ""
    #Interests
    user =client.profile(:fields => %w(interests))
    if user.interests != nil
      addinfo = "Interests: " + user.interests
    end
    #groups and associations
    user =client.profile(:fields => %w(associations))
    if user.associations != nil
      addinfo = addinfo + "\nGroups and Associations: " + user.associations
    end
    #honors
    user =client.profile(:fields => %w(honors))
    if user.honors != nil
      addinfo = addinfo + "\nHonors: " + user.honors
    end
    @teacher.update_attribute(:additional_information, addinfo)

    #Linkedin integration is currently a one time thing so deleting session keys
    #and redirecting to profile like create_profile does
    session[:rtoken]=nil
    session[:rsecret]=nil
    redirect_to '/'+self.current_user.teacher.url     
  end

  def favorites
    @pins = Pin.paginate(:page=> params[:page], :conditions => [ 'user_id = ?', self.current_user.id] )
  end
  
  def teacher_applications
    @featuredjobs = Job.find(:all, :conditions => ['active = ?', true], :order => 'created_at DESC')
    @interviews = Interview.paginate :conditions => ['teacher_id = ?', self.current_user.teacher.id], :order => 'created_at DESC', :page => params[:interview_page], :per_page => 5
    @applications = Application.paginate :conditions => ['teacher_id = ?', self.current_user.teacher.id], :order => 'created_at DESC', :page => params[:application_page], :per_page => 5
    @pendingcount=Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id]).count  
  end

  def appattachments
    @application = Application.find(params[:id])
    @teacher = Teacher.find(self.current_user.teacher.id)
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
