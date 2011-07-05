class Credential < ActiveRecord::Base
  attr_accessible :credentialType, :name, :issuer
  
  belongs_to :teacher
  belongs_to :job
end
