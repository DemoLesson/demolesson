class Event < ActiveRecord::Base
	has_and_belongs_to_many :eventtopics
	has_and_belongs_to_many :eventformats
	has_many :events_eventtopics
	has_many :events_eventformats
end
