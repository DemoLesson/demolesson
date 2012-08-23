# Extensions to the time class to work with time better
class Time
	# Get this same time yesterday
	def yesterday; self - 86400; end

	# Get this same time tomorrow
	def tomorrow; self + 86400; end

	# Change the timezone
	def zone!(v = "local")
		# If we are requesting localtime set to localtime and return
		return self.localtime if v == "local"

		# Otherwise set the timezone offset
		self.getlocal(Time.zone_offset(v))
	end

	# Output in a specific time zone
	def strftime!(format, zone = 'local')
		# Change the zone and output the time
		self.zone!(zone).strftime(format)
	end
end

# Hacks to make the above methods work with Rails DB time objects
class ActiveSupport::TimeWithZone
	def zone!(v = "local")
		# Converts the object to something the real zone can parse
		self.to_time.zone!(v)
	end

	def strftime!(format, zone = 'local')
		# Change the zone and output the time
		self.zone!(zone).strftime(format)
	end
end