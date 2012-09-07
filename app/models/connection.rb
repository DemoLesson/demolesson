class Connection < ActiveRecord::Base
  belongs_to :user
  scope :not_pending, where(:pending => false)

  def self.find_for_user(user_id)
    Connection.find(:all, :conditions => ['owned_by = ?', user_id])
  end

  def owner
    return User.find(self.owned_by)
  end

  def self.add_connect(current_user_id, user_id)
    @previous = Connection.find(:first, :conditions => ['owned_by = ? AND user_id = ?', current_user_id, user_id])

    if @previous == nil

      # Create the connection
      @connection = Connection.new
      @connection.owned_by = current_user_id
      @connection.user_id = user_id

      # If everything saved ok
      if @connection.save
        
        # Notify the other user of my connection request
        UserMailer.userconnect(current_user_id, user_id).deliver
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
