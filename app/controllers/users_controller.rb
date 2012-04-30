class UsersController < ApplicationController
  before_filter :login_required, :only=>['welcome', 'change_password', 'choose_stored']
  USER_ID, PASSWORD = "andreas", "dl2012"
  before_filter :authenticate, :only => [ :fetch_code, :user_list, :school_user_list, :teacher_user_list ]
  
  def create
    @user = User.new(params[:user])
    @success = ""
    if params[:signup] != nil
      passcode = params[:signup][:passcode]
      @passcode = Passcode.find_by_code(passcode)
    end
    
    puts @passcode
    
    if request.post? && @passcode.code == passcode
      if @user.save
        @passcode.destroy
        
        session[:user] = User.authenticate(@user.email, @user.password)
        flash[:notice] = "Signup successful"
        redirect_to_stored
      else
        flash[:notice] = "Signup unsuccessful. Please double check the passcode."
        if passcode
          redirect_to "/signup?passcode="+passcode
        else
          redirect_to "/signup"
        end
      end
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
  
<<<<<<< HEAD
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
=======
  def dont_choose_stored
    self.current_user.create_teacher
    self.current_user.default_home = teacher_path(self.current_user.teacher.id)
    UserMailer.teacher_welcome_email(self.current_user).deliver

    redirect_to current_user.default_home

>>>>>>> f2d5ca58abbae75f153c7544f37edb6f10053576
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
  
  def update
    @user = User.find(self.current_user.id)
    flash[:error] = "Not authorized" and return unless @user.id == self.current_user.id

    respond_to do |format|
      if @user.update_attribute(:avatar, params[:user][:avatar])
        format.html { redirect_to("/", :notice => 'Picture successfully uploaded.') }
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
      @users = User.paginate :per_page => 100, :page => params[:page],
                             :conditions => ['name LIKE ?', "%#{params[:tname]}%"],
                             :order => "created_at DESC"
    else
      @users = User.paginate :per_page =>100, :page =>params[:page],
                             :order => "created_at DESC"
    end
    respond_to do |format|
      format.html { render :teacher_user_list }
    end
  end
  
  def school_user_list
    if request.post?
      user = User.new(:name => params[:contact], :email => params[:email], :password => params[:pass])
      if user.save
        school = School.new(:user => user, :name=> params[:contact], :school_type=> params[:school_type], :map_address => '100 W 1st St', :map_city => 'Los Angeles', :map_state => 5, :map_zip => '90012', :gmaps => 1); 
        if school.save
          flash[:notice] = "The account was successfully created"
        else
          user.destroy
          flash[:notice] = "The account school could not be created"
        end
      else
        flash[:notice] = "The account could not be created."
      end
    end
    @schools = School.paginate :per_page => 100, :page => params[:page],
                               :order => "created_at DESC"
  end

  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:deleted_at, Time.now)
    redirect_to '/teachlist'
  end

  private
   def authenticate
        authenticate_or_request_with_http_basic do |id, password| 
        id == USER_ID && password == PASSWORD
    end
  end
end
