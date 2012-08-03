class Connection < ActiveRecord::Base
  belongs_to :user

  def self.find_for_user(user_id)
    Connection.find(:all, :conditions => ['owned_by = ?', user_id])
  end

  # Return all the connections shared by two users
  def self.common_connections(first_user_id, second_user_id)
    Connection.find(:all, :conditions => [''])
  end
  
  def owner
    return User.find(self.owned_by)
  end
end
