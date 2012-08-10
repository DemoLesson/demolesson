class Event < ActiveRecord::Base
	has_and_belongs_to_many :eventtopics
	has_and_belongs_to_many :eventformats, :join_table => 'events_eventformats'
	has_many :events_eventtopics
	has_many :events_eventformats
	belongs_to :user

	validate :dates

	def dates
		if start_time.blank? || start_time < Time.now
			errors.add(:start_time, "Start time must be in the future")
		end

		if start_time.blank? || end_time.blank? || end_time < start_time
			errors.add(:end_time, "Start time must be before the End Time") 
		end

		if rsvp_deadline.blank? || rsvp_deadline < Time.now
			errors.add(:rsvp_deadline, "The RSVP Deadline must be in the future")
		end
	end

	#validates :name, :description, :virtual, :presence => true
end
