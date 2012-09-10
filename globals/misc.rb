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

# Hash cleaner
class Hash
	def clean!
		self.delete_if do |key, val|
			if block_given?
				yield(key,val)
			else
				# Prepeare the tests
				test1 = val.nil?
				test2 = val === 0
				test3 = val === false
				test4 = val.empty? if val.respond_to?('empty?')
				test5 = val.strip.empty? if val.is_a?(String) && val.respond_to?('empty?')

				# Were any of the tests true
				test1 || test2 || test3 || test4 || test5
			end
		end

		self.each do |key, val|
			if self[key].is_a?(Hash) && self[key].respond_to?('clean!')
				if block_given?
					self[key] = self[key].clean!(&Proc.new)
				else
					self[key] = self[key].clean!
				end
			end
		end

		return self
	end
end