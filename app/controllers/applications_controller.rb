class ApplicationsController < ApplicationController
  before_filter :login_required
  
  # GET /applications
  # GET /applications.xml
  def index
    @job = Job.find(params[:id])
    @applications = Application.find(:all, :conditions => ['job_id = ? AND status = ?', @job.id, 1])
    @applications.each do |application|
      application.viewed = 1
      application.save
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :json => @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.xmlst
  def show
    @application = Application.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :json => @application }
    end
  end
  
  def reject
    @application = Application.find(params[:id])
    @application.reject
    
    respond_to do |format|
      format.html { redirect_to :my_jobs }
    end
  end  
end
