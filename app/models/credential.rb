class Credential < ActiveRecord::Base
  attr_accessible :credentialType, :name, :issuer, :state
  
  belongs_to :teacher
  belongs_to :job
end
