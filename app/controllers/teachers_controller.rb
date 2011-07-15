class TeachersController < ApplicationController

  # GET /teachers
  # GET /teachers.json
  def index
    @teachers = Teacher.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @teachers }
    end
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
    @teacher = Teacher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @teacher }
    end
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def profile
    @teacher = Teacher.find_by_url(params[:url])
    @video = Video.find_by_teacher_id(self.current_user.teacher.id, :limit => 1)
    
    viddler = Viddler::Client.new('5b17ds2ryeks1azgvt0l')
    video_info = viddler.get 'viddler.videos.getDetails', :video_id => @video.video_id
    
    puts video_info
    
    @embed_code = "<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"545\" height=\"429\" id=\"viddler_82e4a107\"><param name=\"movie\" value=\"http://www.viddler.com/simple/#{video_info["video"]["id"]}/\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowFullScreen\" value=\"true\" /><embed src=\"http://www.viddler.com/simple/#{video_info["video"]["id"]}/\" width=\"545\" height=\"429\" type=\"application/x-shockwave-flash\" allowScriptAccess=\"always\" allowFullScreen=\"true\" name=\"viddler_#{video_info["video"]["id"]}\"></embed></object>"

    if @teacher == nil
      redirect_to :root
      flash[:alert]  = "Not found"
    elsif @teacher.currently_seeking == true
      respond_to do |format|
        format.html # profile.html.erb
        format.json  { render :json => @teacher }
      end
    else
      redirect_to :root
      flash[:notice] = "This teacher does not want their information to be publicly available at this time."
    end
  end

  # GET /teachers/new
  # GET /teachers/new.json
  def new
    @teacher = Teacher.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @teacher }
    end
  end

  # GET /teachers/1/edit
  def edit
    @teacher = Teacher.find(params[:id])
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(params[:teacher])

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully created.') }
        format.json  { render :json => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teachers/1
  # PUT /teachers/1.json
  def update
    @teacher = Teacher.find(params[:id])
    flash[:error] = "Not authorized" and return unless @teacher.id == self.current_user.teacher.id

    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        format.html { redirect_to(@teacher, :notice => 'Teacher was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy

    respond_to do |format|
      format.html { redirect_to(teachers_url) }
      format.json  { head :ok }
    end
  end
end
