class ApplicationController < ActionController::Base
  #filter_parameter_logging "password"
  #filter_parameter_logging "password_confirmation"
  skip_before_filter :verify_authenticity_token

  protect_from_forgery
  def login_required
    if session[:user]
      return true
    end
    flash[:alert]='Please login to continue'
    session[:return_to]=request.request_uri
    redirect_to :controller => "users", :action => "login"
    return false 
  end
  
  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    elsif self.current_user.nil?
      redirect_to :controller => "users", :action => "login"
    #elsif self.current_user.default_home.present?
    #  redirect_to(current_user.default_home)
    elsif self.current_user.teacher != nil
      redirect_to :root
    elsif self.current_user.admin != nil
      redirect_to :root
    else
      redirect_to :controller=>'users', :action=>'choose_stored'
    end
  end
end
