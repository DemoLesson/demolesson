class UsersController < ApplicationController
  before_filter :login_required, :only=>['welcome', 'change_password', 'choose_stored']

  def create
    @user = User.new(params[:user])
    @success = ""
    if request.post?  
      if @user.save
        session[:user] = User.authenticate(@user.email, @user.password)
        flash[:notice] = "Signup successful"
        redirect_to_stored
      else
        flash[:notice] = "Signup unsuccessful"
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
	 logger.info "Login successful"
        flash[:message]  = "Login successful"
        redirect_to_stored
        else
	logger.info "Login unsuccessful"
        flash[:warning] = "Login unsuccessful"
      end
    end
  end
  
  def choose_stored
    if request.post?
      if params[:role] == 'teacher'
        self.current_user.create_teacher
        self.current_user.default_home = teacher_path(self.current_user.teacher.id)
        redirect_to current_user.default_home
      elsif params[:role] == 'school'
	self.current_user.create_school
        self.current_user.default_home = school_path(self.current_user.school.id)
        redirect_to self.current_user.default_home
      end
    end  
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end

  def forgot_password
    @message = ""
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        @message = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        @message = "Couldn't send password."
      end
    end
  end

  def change_password
    @user=session[:user]
    @message = ""
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        @message = "Password Changed"
      end
    end
  end

  def show
    if self.current_user.nil?
      redirect_to :action=>'login'
    elsif self.current_user.teacher
      redirect_to :controller=>'teachers', :action=>'edit', :id => self.current_user.teacher.id
    elsif self.current_user.school
      redirect_to :controller=>'schools', :action=>'edit', :id => self.current_user.school.id
    else
      logger.info(self.current_user.inspect)
      redirect_to :controller=>'users', :action=>'select_type'
    end
  end

  def select_type
    @user = current_user
    # render a selection page
  end
end
