class SchoolsController < ApplicationController
  before_filter :login_required
  layout :resolve_layout

  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id])
    @owner = User.find(@school.owned_by)
    
    @json = @school.to_gmaps4rails

    @school_types = [ "District", "Charter", "Private", "Other" ]
    @grades = [ "Pre-K", "Elementary", "Middle", "High School", "Adult School", "Other" ]
    @calendar = [ "Year-round", "Track", "Semester", "Traditional" ]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  def my_schools
    @schools = self.current_user.schools
    
    respond_to do |format|
      format.html # my_schools.html.erb
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])
    @school.owned_by = self.current_user.id
    @school.gmaps = 1

    respond_to do |format|
      if @school.save
        format.html { redirect_to(@school, :notice => 'School was successfully created.') }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => 'School was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find_by_id(params[:id])
    if @school.belongs_to_me(self.current_user)
      @school.remove_associated_data
      @school.destroy
    
      respond_to do |format|
       format.html { redirect_to('/my_schools', :notice => 'School removed.') }
       format.xml  { head :ok }
      end
    end
  end
  
  def change_school_picture
    @school = School.find(params[:id])
  end
  
  def resolve_layout
    case action_name
    when "show"
      "standard"
    else
      "application"
    end
  end
end
