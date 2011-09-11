class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.xml
  def index
    @job = Job.find(params[:id])
    @applications = Application.find(:all, :conditions => ['job_id = ?', @job.id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :json => @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.xml
  def show
    @application = Application.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :json => @application }
    end
  end
  
end
