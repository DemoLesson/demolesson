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
    flash[:notice]='Please login to continue'
    session[:return_to] = request.path
    redirect_to :controller => "users", :action => "login"
    return false
  end

  def check_login_token

    # HACK: Make this run on every page load.
    # If there is a referer set in the page url then
    # Save it to the session for use during registration
    # Or use to auto connect on sharing profiles
    self.check_if_referer

    # If there is no user session but we have login tokens go ahead and connect up the user to the session.
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

  def check_if_referer
    
    # Check if we have a referer set anywhere
    if params.has_key?("_email_referer")
      session[:_referer] = params['_email_referer']
    end

    # Micro url referer
    if params.has_key?("_micro_referer")
      session[:_referer] = params['_micro_referer']
    end
  end

  def current_user

    # Get the currently logged in user
    User.find(session[:user]) unless session[:user].nil?
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
      #dont_choose_stored
      #redirect_to :controller=>'users', :action=>'choose_stored'
    end
  end

  def log_analytic(slug, message, tag = '', data = Array.new)

    # Make sure the slug is a string
    slug = slug.to_s if slug.respond_to?('to_s')

    # Create new analytic
    a = Analytic.new

    # Check if tag is an instance of ActiveRecord::Base
    if tag.is_a?(ActiveRecord::Base)
      tag_string = ''

      # If the tag is an instance of a Model
      # Then convert it to a text storable engine
      tag_string << tag.class.name
      tag_string << ':'
      tag_string << tag.id.to_s

      # If the tag string exists then set the tag
      tag = tag_string unless tag_string.empty?
    end

    # If you want to connect a model
    a.tag = tag unless tag.nil? || !tag.is_a?(String)
    a.message = message if tag.is_a?(String)
    a.slug = slug if tag.is_a?(String)
    a.data = YAML::dump(data)

    # Connect the request uri
    a.path = request.fullpath if request.fullpath.is_a?(String)

    # Link up the currently active user
    a.user = self.current_user unless self.current_user.nil?

    # Save the analytic
    a.save
  end

  def get_analytics(slug, tag = '', date_start = nil, date_end = nil)

    # Make sure the slug is a string
    slug = slug.to_s if slug.respond_to?('to_s')

    # Check if tag is an instance of ActiveRecord::Base
    if tag.is_a?(ActiveRecord::Base)
      tag_string = ''

      # If the tag is an instance of a Model
      # Then convert it to a text storable engine
      tag_string << tag.class.name
      tag_string << ':'
      tag_string << tag.id.to_s

      # If the tag string exists then set the tag
      tag = tag_string unless tag_string.empty?
    end

    # Build the SQL Query string
    sql_query = []
    sql_query << "`slug` = '#{slug}'"
    sql_query << "`tag` = '#{tag}'" unless tag.empty?

    # Add a time constraint
    sql_query << "`created_at` BETWEEN '#{date_start}' AND '#{date_end}'" unless date_start.nil? || date_end.nil?

    # Concatinate the SQL Queries
    sql_query = sql_query.join(' AND ')

    # Find the matching analytics
    Analytic.where(sql_query)
  end
end
