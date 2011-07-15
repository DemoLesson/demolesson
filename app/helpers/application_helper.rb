module ApplicationHelper
  def current_user
    session[:user]
  end
  
  def unread_messages
    @messages = Message.find(:all, :conditions => {:read => false, :user_id_to => self.current_user.id})
    return @messages.count
  end
end
