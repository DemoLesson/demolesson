class BlogEntriesController < ApplicationController
  USER_ID, PASSWORD = "andreas", "dl2011"
  before_filter :authenticate, :only => [ :list, :new, :edit, :create, :update, :destroy ]
  
  # GET /blog_entries
  # GET /blog_entries.xml
  def index
    @blog_entries = BlogEntry.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_entries }
    end
  end

  # GET /blog_entries/1
  # GET /blog_entries/1.xml
  def show
    @blog_entry = BlogEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_entry }
    end
  end
  
  # Admin functionality
  #
  
  def list
    @blog_entries = BlogEntry.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_entries }
    end
  end

  def new
    @blog_entry = BlogEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog_entry }
    end
  end

  def edit
    @blog_entry = BlogEntry.find(params[:id])
  end

  def create
    @blog_entry = BlogEntry.new(params[:blog_entry])

    respond_to do |format|
      if @blog_entry.save
        format.html { redirect_to('/blogadmin', :notice => 'Blog entry was successfully created.') }
        format.xml  { render :xml => @blog_entry, :status => :created, :location => @blog_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @blog_entry = BlogEntry.find(params[:id])

    respond_to do |format|
      if @blog_entry.update_attributes(params[:review])
        format.html { redirect_to('/blogadmin', :notice => 'Review was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog_entry = BlogEntry.find(params[:id])
    @blog_entry.destroy

    respond_to do |format|
      format.html { redirect_to(blog_entries_url) }
      format.xml  { head :ok }
    end
  end
  
  private
   def authenticate
        authenticate_or_request_with_http_basic do |id, password| 
        id == USER_ID && password == PASSWORD
    end
  end
end
