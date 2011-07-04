class Credential < ActiveRecord::Base
  attr_accessible :credentialType, :name, :issuer
end
