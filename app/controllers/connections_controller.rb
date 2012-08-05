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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @connections }
    end
  end

  def add_connection
    @previous=Connection.find(:first, :conditions => ['owned_by = ? AND user_id = ?', self.current_user.id, params[:user_id]])
    if @previous == nil
      @connection = Connection.new
      @connection.owned_by=self.current_user.id
      @connection.user_id=params[:user_id]
      if @connection.save
        UserMailer.userconnect(self.current_user.id, params[:user_id]).deliver
        respond_to do |format|
          format.html { redirect_to :my_connections }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :my_connections }
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
      format.html { redirect_to :my_connections }
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
    @connections= Connection.find(:all, :conditions => ['owned_by = ?', self.current_user.id])
    @pendingcount=Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id]).count
  end

  def pending_connections
    @connections= Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id])
    @pendingcount=Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id]).count
  end

  def userconnections
    @user= User.find(params[:id])
    @connections = Connection.find(:all, :conditions => ['owned_by = ?', params[:id]])
    @pendingcount=Connection.find(:all, :conditions => ['user_id = ? AND pending = true', self.current_user.id]).count
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
