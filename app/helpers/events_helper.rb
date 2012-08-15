module EventsHelper
	# Format the date for the event method
	def date2format(event, row = "start_time", format = "%m/%d/%Y")
		event[row].localtime.to_datetime.strftime(format) unless event[row] == nil
	end

	def event_hours(event, start_time = "start_time", end_time = "end_time", same_day = "%l:%M%P", diff_day = "%m/%d/%Y %l:%M%P")
		return "No dates (This is a big error)" if event[start_time] == nil || event[end_time] == nil

		hours = ''
		if event[start_time].to_datetime.strftime("%m/%d/%Y") == event[end_time].to_datetime.strftime("%m/%d/%Y")
			hours << event[start_time].localtime.to_datetime.strftime(same_day)
			hours << " to "
			hours << event[end_time].localtime.to_datetime.strftime(same_day)
			hours << " on " + event[start_time].localtime.to_datetime.strftime("%m/%d/%Y")
		else
			hours << event[start_time].localtime.to_datetime.strftime(diff_day)
			hours << " to "
			hours << event[end_time].localtime.to_datetime.strftime(diff_day)
		end
	end
end
