#require 'rubygems'
#require 'vzaar'

login = 'demolesson'
application_token = 'aQOoPTPm0lkZIxccc0IXbxjskcfl2qsb1HjoVQJd8'
server_name = 'vzaar.com'

class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all

    vzaar = Vzaar::Base.new :login => login, :application_token => application_token,
      :server => server_name

    if application_token.length > 0
      logger.info 'Testing whoami call.'
      logger.info "Whoami: #{vzaar.whoami}"
    end

    logger.info "Public videos by #{login}:"
    vzaar.video_list(login).each do |video|
      logger.info video.title
    end

    if application_token.length > 0
      logger.info "All videos (public and private) by #{login}:"
      @videos = vzaar.video_list(login, true)
      @videos.each do |video|
        logger.info video.title
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])

    respond_to do |format|
      if @video.save
        format.html { redirect_to(@video, :notice => 'Video was successfully created.') }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to(@video, :notice => 'Video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end
end
