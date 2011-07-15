class Message < ActiveRecord::Base
  attr_accessible :user_id_to, :read, :subject, :body
end
