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
  :password => "Preview1"
}

YEARS_ARRAY = (1900..Time.now.year+10).entries

STATES_ARRAY = [ "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming" ]

MONTHS_ARRAY = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

Time::DATE_FORMATS[:due_time] = "%B %d, %Y at %I:%M %p"
Time::DATE_FORMATS[:interview_time] = "%B %d, %Y, %I:%M %p"
Time::DATE_FORMATS[:message_time] = "%B %d, %Y - %I:%M %p"