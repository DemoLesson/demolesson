class Whiteboard < ActiveRecord::Base
	belongs_to :user

	def map_tag
		_class, _id = self.tag.split(':')
		Kernel.const_get(_class).find(_id)
	end

	def getMessage

		# Get the data to query on
		record = Hash.new
		record["data"] = ActiveSupport::JSON.decode(self.data.nil? ? '{}' : self.data)
		record["user"] = self.user
		record["tag"] = self.map_tag

		# Get the message unparsed
		m = self.message

		# Get all the variables
		vars = m.scan(/{[\w.(),]+}/)

		# Get ready for the parsed data to go here
		parsed_vars = {}

		# Parse the variables
		vars.each do |var|

			# Save the name for later
			var_name = var

			# Go ahead and split the var
			var = var.gsub(/[{}]/, '').split('.')

			# Generate a scope and iterate through each var segment
			scope = record
			var.each_with_index do |var_seg,var_key|

				# If this is the first key pick from the root hash
				if var_key == 0
					raise StandardError, var_seg + ' is not a root key' unless scope.has_key?(var_seg)
					scope = scope[var_seg] if scope.has_key?(var_seg)
					next
				end

				# Is this next is a hash then process
				if scope.is_a?(Hash)
					raise StandardError, var_seg + ' is not an avilable key' unless scope.has_key?(var_seg)
					scope = scope[var_seg]
					next
				end

				# If the next is a object then process
				if scope.is_a?(Object)

					# If there are arguments then seperate them and split
					args = Array.new
					if var_seg['(']
						var_seg = var_seg.split('(')
						args = var_seg[1].gsub(')', '').split(',')
						var_seg = var_seg[0]
					end

					raise StandardError, var_seg + ' is not an avilable method' unless scope.respond_to?(var_seg)
					scope = scope.send(var_seg, *args)
					next
				end

				# Raise an error
				raise StandardError, "Why are we here"
			end

			# Append to the parsed vars
			parsed_vars[var_name] = scope
		end

		# Replace the var instances with the values
		parsed_vars.each do |var,val|
			m = m.gsub(var,val)
		end

		# Return the new message
		return m
	end

	# #
	### Get activity data
	# #
	def self.getActivity

		# Get the current user
		currentUser = User.current
		list_1 = Connection.select("`owned_by` as 'user'").where("`user_id` = ? AND `pending` = '0'", currentUser.id).all
		list_2 = Connection.select("`user_id` as 'user'").where("`owned_by` = ? AND `pending` = '0'", currentUser.id).all

		# Loop through and populate the connections
		connections = [currentUser.id]
		list_1.each do |x|
			connections << x.user
		end
		list_2.each do |x|
			connections << x.user
		end

		# Remove duplicates and turn into CSV
		connections = "'" + connections.uniq.join("','") + "'"

		# Get all the activity
		self.where("`user_id` IN (#{connections})").all
	end

	def self.getMyActivity

		# Get the current user
		currentUser = User.current

		# Get all the activity
		self.where("`user_id` = ?", currentUser.id).all
	end
end
