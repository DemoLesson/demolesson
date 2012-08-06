class Event < ActiveRecord::Base
	has_and_belongs_to_many :eventtopics
	has_and_belongs_to_many :eventformats, :join_table => 'events_eventformats'
	has_many :events_eventtopics
	has_many :events_eventformats

	#validates :name, :description, :virtual, :presence => true
end
