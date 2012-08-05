class Topic < ActiveRecord::Base
	has_and_belongs_to_many :events
	has_many :topics_events
end
