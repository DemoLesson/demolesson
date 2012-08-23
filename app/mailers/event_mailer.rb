class EventMailer < ActionMailer::Base
  default :from => "Demo Lesson <demolesson@demolesson.com>"

  def approved
  end

  def notification(user, event)
  	@event = event
  	start_time = event.start_time.zone!(user.time_zone).strftime("%m/%d/%Y %l:%M%P")
  	@message = "Hi #{user.first_name},\n\nWe wanted to remind you to that an event you RSVPed to is tomorrow. The event details are.\n\n#{event.name} at #{start_time}."
	mail(:to => user.email, :subject => "Event Reminder")
  end
end
