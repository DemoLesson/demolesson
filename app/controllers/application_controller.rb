class ApplicationController < ActionController::Base
  filter_parameter_logging "password"
  filter_parameter_logging "password_confirmation"
  skip_before_filter :verify_authenticity_token

  protect_from_forgery
  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to]=request.request_uri
    redirect_to :controller => "user", :action => "login"
    return false 
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to_url(return_to)
    elsif current_user.home.present?
      redirect_to_url(current_user.home)
    else
      redirect_to :controller=>'users', :action=>'choose_stored'
    end
  end
end
