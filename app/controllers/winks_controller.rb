class WinksController < ApplicationController
  # GET /winks
  # GET /winks.xml
  def index
    @winks = Wink.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @winks }
    end
  end

  # GET /winks/1
  # GET /winks/1.xml
  def show
    @wink = Wink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wink }
    end
  end

  # GET /winks/new
  # GET /winks/new.xml
  def new
    @wink = Wink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wink }
    end
  end

  # GET /winks/1/edit
  def edit
    @wink = Wink.find(params[:id])
  end

  # POST /winks
  # POST /winks.xml
  def create
    @wink = Wink.new(params[:wink])

    respond_to do |format|
      if @wink.save
        format.html { redirect_to(@wink, :notice => 'Wink was successfully created.') }
        format.xml  { render :xml => @wink, :status => :created, :location => @wink }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /winks/1
  # PUT /winks/1.xml
  def update
    @wink = Wink.find(params[:id])

    respond_to do |format|
      if @wink.update_attributes(params[:wink])
        format.html { redirect_to(@wink, :notice => 'Wink was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /winks/1
  # DELETE /winks/1.xml
  def destroy
    @wink = Wink.find(params[:id])
    @wink.destroy

    respond_to do |format|
      format.html { redirect_to(winks_url) }
      format.xml  { head :ok }
    end
  end
end
