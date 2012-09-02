def md5(x)
	unless x.is_a?(String)
		return x unless x.responds_to?('to_s')
		x.to_s if x.responds_to?('to_s')
	end

	# Hash it up
	Digest::MD5.hexdigest(x)
end

# Extensions to ActiveRecord
class ActiveRecord::Base
	def tag!

		# If no id then return false
		return false if self.id.nil?

		# Return the text tag
		self.class.name + ':' + self.id.to_s
	end
end

def mapTag!(tag)

	# If tag is not a string return nil
	return nil unless tag.is_a?(String)

	# If not a tag then return nil
	return nil if tag.count(':') != 1

	# Get the class and ID
	_class, _id = tag.split(':')

	# Get the model by class and ID
	Kernel.const_get(_class).find(_id)
end