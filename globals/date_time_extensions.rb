class Time
	# Get this same time yesterday
	def yesterday; self - 86400; end

	# Get this same time tomorrow
	def tomorrow; self + 86400; end

	# Change the timezone
	def zone!(v = "local"); return self.localtime if v == "local"; self.getlocal(Time.zone_offset(v)); end;
end