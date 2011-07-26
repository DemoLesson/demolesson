class Message < ActiveRecord::Base
  attr_accessible :user_id_to, :read, :subject, :body
  validates_presence_of :subject, :body, :message => "Please enter a subject and/or message."
end
