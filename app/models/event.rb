class Event < ActiveRecord::Base
	has_and_belongs_to_many :topics
	has_many :topics_events
end
