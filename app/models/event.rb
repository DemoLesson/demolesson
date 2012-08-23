class Event < ActiveRecord::Base
	# Set the page length
	self.per_page = 10

	# Create connections
	has_and_belongs_to_many :eventtopics
	has_and_belongs_to_many :eventformats, :join_table => 'events_eventformats'
	has_many :events_eventtopics
	has_many :events_eventformats
	belongs_to :user

	# RSVP Connections (this is will look kinda weird)
	has_and_belongs_to_many :rsvp, :class_name => 'User', :join_table => 'events_rsvps'
	has_many :events_rsvps

	# Validations
	validate :dates

	def dates
		if start_time.blank? || end_time.blank? || end_time < start_time
			errors.add(:end_time, "Start time must be before the End Time") 
		end

		# Block the errors if this was an update
		if id.nil?
			if start_time.blank? || start_time < Time.now.yesterday
				errors.add(:start_time, "Start time must be in the future")
			end

			# If an RSVP Deadline was provided
			# Maker sure it is before the start time
			if !rsvp_deadline.blank? && start_time < rsvp_deadline
				errors.add(:rsvp_deadline, "The RSVP Deadline must be in the future")
			end
		end
	end

	#validates :name, :description, :virtual, :presence => true
end
