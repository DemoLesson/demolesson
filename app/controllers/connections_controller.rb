require 'mail'
class ConnectionsController < ApplicationController
  before_filter :login_required

  # GET /connections
  # GET /connections.json
  def index
    if params[:connectsearch]
      @connections = Teacher.search(params[:connectsearch]).paginate(:per_page => 25, :page => params[:page])
    else
      @connections = Teacher.paginate(:page=> params[:page], :per_page => 25)
    end
    @my_connections = Connection.find_for_user(self.current_user.id).collect(&:user_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @connections }
    end
  end

  def add_connection(respond = true)
    # Check and see if we are already connected
    @previous = Connection.find(:first, :conditions => ['owned_by = ? AND user_id = ?', self.current_user.id, params[:user_id]])

    # If we are not go ahead and initiate the connection
    if @previous == nil

      # Create the connection
      @connection = Connection.new
      @connection.owned_by = self.current_user.id
      @connection.user_id = params[:user_id]

      # If everything saved ok
      if @connection.save
        # Notify the other user of my connection request
        UserMailer.userconnect(self.current_user.id, params[:user_id]).deliver

        # If respond is set to true then lets redirect
        if respond

          # Redirect to "My Connections"
          respond_to do |format|
            format.html { redirect_to :pending_connections }
          end
        end
      end

    # Whoops we're already connected
    else

      # If respond is set to true then lets redirect
      if respond

        # Redirect to "My Connections"
        respond_to do |format|
          format.html { redirect_to :my_connections }
        end
      end
    end
  end

  def remove_connection
    @connection = Connection.find(:first, :conditions => ['owned_by = ? and user_id = ?', self.current_user.id ,params[:user_id]])
    @oconnection = Connection.find(:first, :conditions => ['owned_by = ? and user_id = ?', params[:user_id], self.current_user.id])
    @connection.destroy
    if @oconnection != nil
      @oconnection.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to :my_connections }
    end
  end

  def remove_pending
    @connection = Connection.find(:first, :conditions => ['owned_by = ? and user_id = ? and pending = true', params[:user_id], self.current_user.id])
    @connection.destroy
    
    respond_to do |format|
      format.html { redirect_to :pending_connections }
    end
  end

  def accept_connection
    @connect= Connection.find(:first, :conditions => ['owned_by = ? and user_id = ?', params[:user_id], self.current_user.id])
    @connect.pending = false
    if @connect.save
      @connection = Connection.new
      @connection.owned_by=self.current_user.id
      @connection.user_id=params[:user_id]
      @connection.pending=false
      if @connection.save
        Activity.create(:creator_id => @connection.user_id, :user_id => @connection.owned_by, :activityType => 10)
        Activity.create(:creator_id => @connection.owned_by, :user_id => @connection.user_id, :activityType => 10)
        respond_to do |format|
          format.html { redirect_to :my_connections }
        end
      end
    end
  end

  def my_connections
    @connections= Connection.not_pending.find(:all, :conditions => ['owned_by = ?', self.current_user.id])
  end

  def pending_connections
    @connections= Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id])
    @my_pending_connections=Connection.find(:all, :conditions => ['owned_by = ? AND pending = true', self.current_user.id])
  end

  def userconnections
    @user= User.find(params[:id])
    @connections = Connection.not_pending.find_for_user(params[:id])
    @my_connections = Connection.find_for_user(self.current_user.id)
  end

  def add_and_redir

    # Make sure we have a user_id
    unless params.has_key?("user_id")
      raise StandardError, "Were missing the user id to connect to"
    end

    # Make sure we have a redirection url
    unless params.has_key?("redir")
      raise StandardError, "We can't redirect you anywhere unless you provide us with the url"
    end

    # Create the connection and redirect
    self.add_connection(false)
    redirect_to params['redir']
  end

  def inviteconnections
    @my_connection = Connection.find_for_user(self.current_user.id)
    @default_message = "Hey! I'd love to add you to my professional teaching network at DemoLesson."
  end

  def inviteconnection
    if params[:emails].size == 0
      redirect_to :back, :notice => "Must have at least one email."
    end
    notice = ""
    params[:emails].split(',').each do |email|
      # Clean up the email
      email = email.strip

      begin
        # Parse email address
        mail = Mail::Address.new(email)
        demail = mail.address
        @user = User.find(:first, :conditions => ["email = ?", email])
        unless @user.nil?
          # Send out basic invite email
          UserMailer.refer_site(self.current_user.name, email, self.current_user).deliver
        else
          @invite = ConnectionInvite.new
          @invite.user_id = self.current_user.id
          @invite.email = demail
          if @invite.save
            invitestring = User.random_string(20)
            @invite.update_attribute(:url, invitestring + @invite.id.to_s)
            url = "http://#{request.host_with_port}/card?i=" + @invite.url
            mail = UserMailer.connection_invite(self.current_user.name, email, url, params[:message]).deliver
            notice += "Your invite to " + demail + " has been sent."
          else 
            notice += email + ": "+ @invite.errors.full_messages.to_sentence
          end
        end
      rescue Mail::Field::ParseError
        notice += "Could not parse " + email
      end
    end
    redirect_to :root, :notice => notice
  end

  # DELETE /connections/1
  # DELETE /connections/1.json
  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html { redirect_to connections_url }
      format.json { head :ok }
    end
  end
end
