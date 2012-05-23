class ApplicationController < ActionController::Base
  #filter_parameter_logging "password"
  #filter_parameter_logging "password_confirmation"
  skip_before_filter :verify_authenticity_token
  before_filter :check_login_token

  protect_from_forgery
  def login_required
    if session[:user]
      return true
    end
    flash[:alert]='Please login to continue'
    session[:return_to] = request.path
    redirect_to :controller => "users", :action => "login"
    return false
  end

  def check_login_token
    if !session[:user] && cookies[:login_token_user]
      login_token = LoginToken.find_by_user_id_and_token_value(cookies[:login_token_user], cookies[:login_token_value])
      if login_token
        if login_token.expires_at >= Time.new
          session[:user] = User.find(login_token.user_id)
        else
          LoginToken.delete(login_token.id)
        end
      end
    end
  end
  
  def current_user
    session[:user]
  end
  
  def is_admin
  end
  
  def belongs_to_me
  end

  def redirect_to_stored
    if session[:return_to] != nil
      return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to(return_to)
    elsif self.current_user.nil?
      redirect_to :controller => "users", :action => "login"
    #elsif self.current_user.default_home.present?
    #  redirect_to(current_user.default_home)
    elsif self.current_user.teacher != nil
      redirect_to :root
    elsif self.current_user.school != nil || self.current_user.is_shared == true
      redirect_to :root
    else
      dont_choose_stored
      #redirect_to :controller=>'users', :action=>'choose_stored'
    end
  end
end
