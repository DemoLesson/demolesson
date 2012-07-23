class UsersController < ApplicationController
  before_filter :login_required, :only=>['welcome', 'change_password', 'choose_stored', 'edit']
  USER_ID, PASSWORD = "andreas", "dl2012"
  before_filter :authenticate, :only => [ :fetch_code, :user_list, :school_user_list, :teacher_user_list, :deactivated_user_list, :organization_user_list,:manage ]
  
  def create
    @user = User.new(params[:user])
    @success = ""

    if request.post?
      if @user.save
        session[:user] = User.authenticate(@user.email, @user.password)
        flash[:notice] = "Signup successful"
        redirect_to_stored
      else
        flash[:notice] = "Signup unsuccessful."
        redirect_to "/"
      end
    end
  end

  def create_admin
    @user = User.new(:name => params[:name], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
    @success = ""
    if @user.save
      session[:user] = User.authenticate(@user.email, @user.password)
      @school = School.new(:user => @user, :name=> params[:schoolname], :map_address => '100 W 1st St', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :gmaps => 1); 
      if @school.save
        o=Organization.create
        o.update_attribute(:owned_by, @user.id)
        o.update_attribute(:name, params[:schoolname])
        UserMailer.school_signup_email(params[:name], params[:schoolname], params[:email], params[:phonenumber], @school).deliver
        self.current_user.default_home = school_path(self.current_user.school.id)
        redirect_to :school_thankyou, :notice => "Signup successful!"
      else
        @user.destroy
          flash[:notice] = "Signup unsuccessful."
      end
    else
      flash[:notice] = "Signup unsuccessful."
      redirect_to "/"
    end
  end
  
  def verify
    User.verify!(params[:user_id], params[:verification_code])
    redirect_to_stored
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:email], params[:user][:password])
        self.current_user.update_login_count
	      logger.info "Login successful"
	    # create token/store cookie
	    if params[:remember_me]
    	  login_token = LoginToken.generate_token_for!(session[:user])
          cookies[:login_token_user] = { :value => login_token.user_id, :expires => login_token.expires_at }
          cookies[:login_token_value] = { :value => login_token.token_value, :expires => login_token.expires_at }
	    end
        redirect_to_stored
      else
	    #logger.info "Login unsuccessful"
        flash[:notice] = "Login unsuccessful"
      end
    end
  end
  
  def choose_stored
    if request.post?
      if params[:role] == 'teacher'
        self.current_user.create_teacher
        self.current_user.default_home = teacher_path(self.current_user.teacher.id)
        UserMailer.teacher_welcome_email(self.current_user).deliver
        
        redirect_to current_user.default_home
      elsif params[:role] == 'school'
        self.current_user.create_school
        self.current_user.default_home = school_path(self.current_user.school.id)
        redirect_to :root
        #redirect_to :root, :notice => 'Thank you for signing up. Please contact our support team at support@demolesson.com to start posting jobs.'
      end
    end
  end

    def dont_choose_stored
      self.current_user.create_teacher
      self.current_user.default_home = teacher_path(self.current_user.teacher.id)
      UserMailer.teacher_welcome_email(self.current_user).deliver

      redirect_to current_user.default_home
    end

  #  def choose_stored
  #    if request.post?
  #      if params[:role] == 'teacher'
  #        self.current_user.create_teacher
  #        self.current_user.default_home = teacher_path(self.current_user.teacher.id)
  #        UserMailer.teacher_welcome_email(self.current_user).deliver
  #        
  #        redirect_to current_user.default_home
  #      elsif params[:role] == 'school'
  #	      #self.current_user.create_school
  #        #self.current_user.default_home = school_path(self.current_user.school.id)
  #        redirect_to :root, :notice => 'Thank you for signing up. Please contact our support team at support@demolesson.com to start posting jobs.'
  #      end
  #    end
  #  end

  def logout
    session[:user] = nil
    flash[:notice] = 'You\'ve been logged out.'
    login_token = LoginToken.find_by_user_id(cookies[:login_token_user])
    if login_token
      cookies[:login_token_user] = { :value => nil, :expires => Time.new - 1.day }
      cookies[:login_token_value] = { :value => nil, :expires => Time.new - 1.day }
      LoginToken.delete(login_token.id)
    end
    redirect_to :root
  end

  def forgot_password
    @message = ""
    if request.post?
      @u = User.find_by_email(params[:user][:email])
      if @u and @u.send_new_password
        message = "A new password has been sent by email."
        flash[:notice] = message
        redirect_to :action => :login
      else
        @message = "Couldn't send password, check if the email you provided was correct."
      end
    end
  end

  def change_password
    @user=session[:user]
    @message = ""
    if request.post?
      @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        @message = "Password Changed"
      end
    end
  end

  def show
    if self.current_user.nil?
      redirect_to :action=>'login'
    # elsif self.current_user.teacher
    #       redirect_to :controller=>'teachers', :action=>'edit', :id => self.current_user.teacher.id
    #     elsif self.current_user.school
    #       redirect_to :controller=>'schools', :action=>'edit', :id => self.current_user.school.id
    # else
    #  logger.info(self.current_user.inspect)
    #  redirect_to :controller=>'users', :action=>'select_type'
    else
      @user = User.find(params[:id])
      @school = School.find_by_owned_by(@user.id, :limit => 1)
      @teacher = Teacher.find_by_user_id(@user.id, :limit => 1)
      
      respond_to do |format|
        format.html
      end
    end
  end

  def select_type
    @user = current_user
    # render a selection page
  end
  
  def edit
    @user = User.find(self.current_user.id)
  end

  def accounts
    @organization = self.current_user.organization
    if self.current_user.is_shared
      u=SharedUsers.find(:first,:conditions => { :user_id => self.current_user.id})
      @user=User.find(u.owned_by)
    else
      @user=self.current_user
    end
    if self.current_user.is_shared
      sharedschool = SharedUsers.find(:first, :conditions => {:user_id => self.current_user.id})
      @members = SharedUsers.find(:all, :conditions => { :owned_by => sharedschool.owned_by})
    else
      @members = SharedUsers.find(:all, :conditions => { :owned_by => self.current_user.id})
    end
  end
  
  def update
    @user = User.find(self.current_user.id)
    flash[:error] = "Not authorized" and return unless @user.id == self.current_user.id

    respond_to do |format|
      if @user.update_attribute(:avatar, params[:user][:avatar])
        format.html { redirect_to('/'+self.current_user.teacher.url,  :notice => 'Picture successfully uploaded.') }
        format.json  { head :ok }
      else
        format.html { redirect_to("/", :notice => 'Picture could not be uploaded.') }
      end
    end
  end

  def change_picture
    @user = User.find(self.current_user.id)
  end
  
  def update_settings
    @user = User.find(self.current_user.id)    
    action = @user.update_settings(params[:user])

    respond_to do |format|
      format.html { redirect_to @user, :notice => action }
    end
  end
  
  def change_password
    @user = User.find(self.current_user.id)
    action = @user.change_password(params[:confirm])

    respond_to do |format|
      format.html { redirect_to :root, :notice => action }
    end
  end

  def email_settings
    @user = User.find(self.current_user.id)
    @user.update_attribute(:emailsubscription, params[:user][:emailsubscription])
    respond_to do |format|
      format.html { redirect_to :root, :notice => "You have updated your email settings." }
    end
  end

  def change_org_info
    @organization = self.current_user.organization
    if self.current_user.is_shared
      u=SharedUsers.find(:first,:conditions => { :user_id => self.current_user.id})
      @user=User.find(u.owned_by)
    else
      @user = User.find(self.current_user.id)
    end
    @user.update_attributes(:email=>params[:email],:name=>params[:name])
    @organization.update_attribute(:name, params[:organization])
    redirect_to :root
  end
  
  def fetch_code
    @passcode = Passcode.find_by_given_out(nil)
    @passcode.given_out = true
    @passcode.save!
    
    respond_to do |format|
      format.html { render :fetch_code, :layout => nil }
    end
  end
  
  def user_list
    @users = User.find(:all, :order => 'created_at DESC')
    @teachercounter = 0
    @schoolcounter = 0
    @schoolsnumber = 0
    respond_to do |format|
      format.html { render :user_list }
    end
  end
  
  def teacher_user_list
    if params[:tname]
      @users = User.find :all, :conditions => ['name LIKE ?', "%#{params[:tname]}%"],
        :order => "created_at DESC"
    else
      @users = User.find :all, :order => "created_at DESC"
    end
    @users=@users.reject{ |user| user.teacher == nil }
    if params[:vid]
      @users=@users.reject{ |user| user.videos.count == 0 }
    end
    if params[:applied]
      @users=@users.reject{|user| user.applications.count == 0}
    end
    @usercount = 0
    @videos = 0
    @users.each do |user|
      @usercount+=1
      if user.teacher.videos.count != 0
        @videos += 1
      end
    end
    @users=@users.paginate :page => params[:page], :per_page => 100
    respond_to do |format|
      format.html { render :teacher_user_list }
    end
  end

  def deactivated_user_list
    if request.post?
      @user = User.unscoped.find(params[:user])
      @user.update_attribute(:deleted_at, nil)
    end
    @users = User.unscoped.find(:all)
    @users=@users.reject { |user| user.deleted_at == nil }
    @usercount = @users.count
    @teachercount = 0
    @admincount = 0
    @users.each do |user|
      if user.teacher != nil
        @teachercount+=1
      else
        @admincount+=1
      end
    end
    @users=@users.paginate :page => params[:page], :per_page => 100
  end

  def school_user_list
    if request.post?
      user = User.new(:name => params[:contact], :email => params[:email], :password => params[:pass])
      if user.save
        school = School.new(:user => user, :name=> params[:name], :school_type=> params[:school_type], :map_address => '100 W 1st St', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :gmaps => 1); 
        if school.save
          o=Organization.create
          o.update_attribute(:owned_by, user.id)

          flash[:notice] = "The account was successfully created"
        else
          user.destroy
          flash[:notice] = "The account school could not be created"
        end
      else
        flash[:notice] = "The account could not be created."
      end
    end
    if params[:orgname] || params[:contactname] || params[:emailaddress]
      #The default scope for schools is currently joined with users
      #so I can select rows from the users table
      @schools = School.find :all,
        :conditions => ['schools.name LIKE ? AND users.name LIKE ? AND users.email LIKE ?', "%#{params[:orgname]}%", "%#{params[:contactname]}%", "%#{params[:emailaddress]}%"],
        :order => "created_at DESC"
    else
      @schools = School.find :all,
        :order => "created_at DESC"
    end
    #number of shared users+admins that created the orginal accounts
    #Full admins+Limited admins+organizations
    @admincount = SharedUsers.count+Organization.count
    @schools=@schools.paginate :per_page => 100, :page => params[:page]

    #count the total of applicants and jobs instead of based on what is searched
    @jobcount=0
    @applicants = 0
    School.all.each do |school|
      user = User.find(school.owned_by) 
      @jobcount+=school.jobs.count
      school.jobs.each do |job| 
        @applicants = @applicants + job.applications.count 
      end
    end
  end

  def organization_user_list
    if params[:orgname]
      @organizations=Organization.all
      #Since the names we can select can be eitheir the organization or the name of the first school instead of using ActiveRecord for selection, reject is used
      @organizations=@organizations.select { |organization| organization.oname.downcase.include?(params[:orgname])} 
      @organizations=@organizations.paginate :page => params[:page], :per_page => 25
    else
      @organizations=Organization.paginate :page => params[:page], :per_page => 25
    end
  end

  def manage
    @schools = School.find(:all, :conditions => { :owned_by => params[:id] })
    @organization = Organization.find(:first, :conditions => { :owned_by => params[:id] })
    shared=SharedUsers.find(:all, :conditions => { :owned_by => params[:id]}).collect(&:user_id)
    @members=User.find(shared)
    if request.post?
      if self.current_user.is_limited
        redirect_to :back, :notice => 'You are not authorized to do this action.'
        return
      end
      @organization.update_attributes(:name => params[:name], :job_allowance => params[:job_allowance], :admin_allowance => params[:admin_allowance], :school_allowance => params[:school_allowance])
      redirect_to :schoollist
    end
  end

  def edit_member
    @user = User.find(params[:id])
    @schools = self.current_user.schools 
    if request.post?
      if self.current_user.is_limited
        redirect_to :back, :notice => 'You are not authorized to do this action.'
        return
      end
      @user.update_attributes(:name => params[:name], :email => params[:email])
      @user.update_attribute(:is_limited, params[:is_limited])
      #on update delete all rows then reGreate based on editted version if the user is_limited
      if @user.is_limited == true
        SharedSchool.where(:user_id => @user.id).destroy_all
        params[:school_ids].each do |school|
          schoolowner = School.find(school)
          SharedSchool.create(:owned_by => schoolowner.owned_by, :school_id => school, :user_id => @user.id)
        end
      end
      flash[:notice] = "User update successful"
      redirect_to '/accounts/'+self.current_user.id.to_s
    end
  end

  def new_member
    @schools = self.current_user.schools 
    if request.post?
      if params[:is_limited] == nil
        redirect_to :back, :notice => 'You must select a type'
        return
      end
      if params[:school_ids] == nil && params[:is_limited] == true
        redirect_to :back, :notice => 'You must select at least one school'
        return
      end
      if self.current_user.is_limited
        redirect_to :back, :notice => 'You are not authorized to do this action.'
        return
      end
      total=self.current_user.organization.totaladmins
      if self.current_user.organization.admin_allowance <= (total)
        flash[:notice]="Your current admin account allowance is too small to create this user.  Please contact support in order to increase it."
        return
      end
      @user= User.new(:name => params[:name], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])

      if @user.save
        self.current_user.organization.update_attribute(:totaladmins,total+1)
        schoolowner=nil
        @user.update_attribute(:is_limited, params[:is_limited])
        @user.update_attribute(:is_shared, true)
        SharedUsers.create(:owned_by => self.current_user.organization.owned_by, :user_id => @user.id)
        if @user.is_limited == true
          params[:school_ids].each do |school|
            schoolowner = School.find(school)
            SharedSchool.create(:owned_by => schoolowner.owned_by, :school_id => school, :user_id => @user.id)
          end
        end
        flash[:notice] = "User creation successful"
        redirect_to '/accounts/'+self.current_user.id.to_s
      else
        flash[:notice] = "User could not be created"
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if params[:deactivate] 
      @user.update_attribute(:deleted_at, Time.now)
    else
      @user.cleanup
      @user.destroy
    end
    #stay on same page
    redirect_to :back
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |id, password| 
      id == USER_ID && password == PASSWORD
    end
  end
end

