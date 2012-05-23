class Organization < ActiveRecord::Base
  belongs_to :user, :foreign_key => :owned_by
  attr_protected :owned_by

  validates_uniqueness_of :owned_by
end
