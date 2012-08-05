class Vouch < ActiveRecord::Base
  validates_presence_of :voucher_id
  validates_presence_of :vouchee_id

  belongs_to :voucher, :class_name => 'User'
  belongs_to :vouchee, :class_name => 'User'
end
