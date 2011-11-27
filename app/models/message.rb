class Message < ActiveRecord::Base
  attr_accessible :user_id_to, :user_id_from, :read, :subject, :body
  validates_presence_of :subject, :body, :message => "Please enter a subject and/or message."
  
  self.per_page = 15
  
  def activify
    @activity = Activity.new
    @activity.user_id = self.user_id_to
    @activity.creator_id = self.user_id_from
    @activity.activityType = 1
    @activity.message_id = self.id
    @activity.interview_id = 0
    @activity.application_id = 0
    @activity.save    
  end
end
