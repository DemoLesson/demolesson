class Connection < ActiveRecord::Base
  belongs_to :user

  def owner
    return User.find(self.owned_by)
  end
end
