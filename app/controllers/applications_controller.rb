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
    
    @school = School.find(@job.school_id)
    @owner = User.find(@school.owned_by)

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

  def attachments
    @application= Application.find(params[:id])
    @profileassets= Asset.find(:all, :conditions => ['teacher_id = ? AND assetType = ?', @application.teacher_id, 0])
    respond_to do |format|
      format.html # attachments.html.erb
    end
  end
  
  def reject
    @application = Application.find(params[:id])
    @teacher_id = @application.teacher_id
    @job_id = @application.job_id
    @application.reject
    
    respond_to do |format|
      UserMailer.rejection_notification(@teacher_id, @job_id, self.current_user.name).deliver
      format.html { redirect_to :my_jobs }
    end
  end  
end
