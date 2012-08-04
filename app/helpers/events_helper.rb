module EventsHelper
	# Format the date for the event method
	def date2format(event, row = "start_time", format = "%m/%d/%Y")
		event[row].to_datetime.strftime(format)
	end

	def event_hours(event, start_time = "start_time", end_time = "end_time", same_day = "%l:%M%P", diff_day = "%m/%d/%Y %l:%M%P")
		hours = ''
		if event[start_time].to_datetime.strftime("%m/%d/%Y") == event[end_time].to_datetime.strftime("%m/%d/%Y")
			hours << event[start_time].to_datetime.strftime(same_day)
			hours << " to "
			hours << event[end_time].to_datetime.strftime(same_day)
		else
			hours << event[start_time].to_datetime.strftime(diff_day)
			hours << " to "
			hours << event[end_time].to_datetime.strftime(diff_day)
		end
	end
end
