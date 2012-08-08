class Analytic < ActiveRecord::Base
	belongs_to :user

	def map_tag
		_class, _id = self.tag.split(':')
		Kernel.const_get(_class).find(_id)
	end
end
