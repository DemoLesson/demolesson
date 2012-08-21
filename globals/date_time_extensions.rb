 
 # Get this same time yesterday
 def Time.yesterday; now - 86400; end

 # Get this same time tomorrow
 def Time.tomorrow; now + 86400; end