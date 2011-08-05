class School < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :user, :foreign_key => :owned_by
  attr_protected :owned_by
end
