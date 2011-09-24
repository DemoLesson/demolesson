class BlogEntriesController < ApplicationController
  # GET /blog_entries
  # GET /blog_entries.xml
  def index
    @blog_entries = BlogEntry.all

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
end
