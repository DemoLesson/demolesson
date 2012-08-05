class EventsTopics < ActiveRecord::Base
	has_many :event
	has_many :topic
end
