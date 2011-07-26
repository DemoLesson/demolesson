class Pin < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :user
end
