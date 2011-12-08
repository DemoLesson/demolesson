class InterviewsController < ApplicationController
  before_filter :login_required
  
  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interviews }
    end
  end
  
  # GET /my_interviews
  # GET /my_interviews.json
  
  def my_interviews
    @interviews = Interview.find(:all, :conditions => ['teacher_id = ?', self.current_user.teacher.id])
    
    respond_to do |format|
      format.html # my_interviews.html.erb
      format.json { render json: @interviews }
    end
  end
  
  # POST /interviews/respond
  # POST /interviews/respond.json
  
  def respond
    @interview = Interview.find(params[:id])
    @job = Job.find(@interview.job_id)

    respond_to do |format|
      if self.current_user.teacher == nil || @interview.teacher_id != self.current_user.teacher.id
        render :nothing => true, :status => "Forbidden" 
      else
        format.html
        format.json
      end
    end
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
    @interview = Interview.find(params[:id])

    respond_to do |format|
      if self.current_user.teacher != nil
        if @interview.teacher_id != self.current_user.teacher.id
          render :nothing => true, :status => "Forbidden"
        else
          format.html # show.html.erb
          format.json { render json: @interview }
        end
      elsif self.current_user.school != nil
        if Job.find(@interview.job_id).school_id != self.current_user.school.id
          render :nothing => true, :status => "Forbidden"
        else
          format.html # show.html.erb
          format.json { render json: @interview }
        end
      end
    end
  end

  # POST /interviews/new
  # POST /interviews/new.json
  def new
    @interview = Interview.new
    
    @teacher = Teacher.find_by_id(params[:teacher_id])
    @job = Job.find_by_id(params[:job_id])
    @user = User.find(@teacher.user_id)
    @school = School.find(@job.school_id)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interview }
    end
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(params[:interview])
    
    @interview.teacher_id = params[:interview][:teacher_id]
    @interview.job_id = params[:interview][:job_id]
    
    respond_to do |format|
      if @interview.save
        UserMailer.interview_notification(@interview.teacher_id, @interview.message).deliver
        
        format.html { redirect_to :interviews, notice: 'Interview request has been sent.' }
        format.json { render json: @interview, status: :created, location: @interview }
      else
        format.html { render action: "new" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /interviews/1
  # PUT /interviews/1.json
  def update
    @interview = Interview.find(params[:id])

    respond_to do |format|
      if @interview.update_attributes(params[:interview])
        @interview.activify
        format.html { redirect_to '/my_interviews', notice: 'Interview details have been updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview = Interview.find(params[:id])
    @interview.destroy

    respond_to do |format|
      format.html { redirect_to interviews_url }
      format.json { head :ok }
    end
  end
end
