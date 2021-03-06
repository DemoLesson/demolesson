class Connection < ActiveRecord::Base
  belongs_to :user

  def self.find_for_user(user_id)
    Connection.find(:all, :conditions => ['owned_by = ?', user_id])
  end

  def owner
    return User.find(self.owned_by)
  end
end
