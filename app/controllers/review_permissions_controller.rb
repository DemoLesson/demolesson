class ReviewPermissionsController < ApplicationController
  # GET /review_permissions
  # GET /review_permissions.xml
  def index
    @review_permissions = ReviewPermission.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @review_permissions }
    end
  end

  # GET /review_permissions/1
  # GET /review_permissions/1.xml
  def show
    @review_permission = ReviewPermission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review_permission }
    end
  end

  # GET /review_permissions/new
  # GET /review_permissions/new.xml
  def new
    @review_permission = ReviewPermission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review_permission }
    end
  end

  # GET /review_permissions/1/edit
  def edit
    @review_permission = ReviewPermission.find(params[:id])
  end

  # POST /review_permissions
  # POST /review_permissions.xml
  def create
    @review_permission = ReviewPermission.new(params[:review_permission])

    respond_to do |format|
      if @review_permission.save
        format.html { redirect_to(@review_permission, :notice => 'Review permission was successfully created.') }
        format.xml  { render :xml => @review_permission, :status => :created, :location => @review_permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @review_permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /review_permissions/1
  # PUT /review_permissions/1.xml
  def update
    @review_permission = ReviewPermission.find(params[:id])

    respond_to do |format|
      if @review_permission.update_attributes(params[:review_permission])
        format.html { redirect_to(@review_permission, :notice => 'Review permission was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @review_permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /review_permissions/1
  # DELETE /review_permissions/1.xml
  def destroy
    @review_permission = ReviewPermission.find(params[:id])
    @review_permission.destroy

    respond_to do |format|
      format.html { redirect_to(review_permissions_url) }
      format.xml  { head :ok }
    end
  end
end
