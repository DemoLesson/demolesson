# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Preview::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "demolesson.com",
  :authentication => :plain,
  :user_name => "demolesson@demolesson.com",
  :password => "4luvOFteaching!"
}

YEARS_ARRAY = (1900..Time.now.year).entries