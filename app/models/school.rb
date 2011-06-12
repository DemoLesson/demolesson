class School < ActiveRecord::Base
  belongs_to :user, :foreign_key => :owned_by
end
