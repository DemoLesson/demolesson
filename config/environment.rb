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

#config.gem "vzaar", :lib => "vzaar", :version => "0.2.3", :source => "https://rubygems.org/downloads/vzaar-0.2.3.gem"
#config.gem 'geokit'
