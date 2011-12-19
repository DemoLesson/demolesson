class JobsController < ApplicationController
  before_filter :login_required
  
  # GET /jobs
  # GET /jobs.xml
  def index
    if params[:special_needs]
      @jobs = Job.is_active.paginate(:page => params[:page], :conditions => ['special_needs = ?', params[:special_needs]], :order => 'created_at DESC')
    #if params[:zipcode]
    #  @jobs = Job.is_active.paginate(:page => params[:page], :conditions => [''], :order => 'created_at DESC')
    elsif params[:search] 
      @search = Job.search do 
        fulltext params[:search]
      end
      @jobs = @search.results
    else
      @jobs = Job.is_active.paginate(:page => params[:page], :order => 'created_at DESC')
    end
    @title = "Jobs"

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end
  
  def auto_complete_search
    begin
      @items = Job.complete_for(params[:search])
    rescue ScopedSearch::QueryNotSupported => e
      @items = [{:error =>e.to_s}]
    end
    render :json => @items
  end
  
  def apply
    @job = Job.find(params[:id])
    @job.apply(self.current_user.teacher.id)
    
    respond_to do |format|
      format.html { redirect_to :action => :show, :id => @job.id }
    end
  end

  def my_jobs
    if params[:school_id]
      @school = School.find(params[:school_id])
    else
      @school = School.find(self.current_user.school)
    end  
    @jobs = Job.paginate(:page => params[:page], :conditions => ['school_id = ?', @school.id])
    @user = self.current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])
    if self.current_user.teacher != nil
      @application = Application.find(:first, :conditions => ['job_id = ? AND teacher_id = ?', @job.id, self.current_user.teacher.id])
    end
    
    respond_to do |format|
      if @job.active == true || @job.belongs_to_me(self.current_user) == 1
        format.html # show.html.erb
        format.json  { render :json => @job }
      else
        format.html { redirect_to :root, :notice => 'This posting is not currently available.' }
      end
    end
  end

  # GET /jobs/new
  # GET /jobs/new.xml
  def new
    @job = Job.new
    @subjects = Subject.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @subjects = Subject.all
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])
    @job.school_id = params[:school_id][0]

    respond_to do |format|
      if @job.save
        if params[:subjects]
          @job.update_subjects(params[:subjects])
        end
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    @job = Job.find(params[:id])
    
    respond_to do |format|
      if @job.update_attributes(params[:job])
        if params[:subjects]
          @job.update_subjects(params[:subjects])
        end
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
