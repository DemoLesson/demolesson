class EventsController < ApplicationController
  layout 'standard', :except => [:list]

  # GET /events
  # GET /events.json
  def index
    # Filtered Events
    @events = Event.all
    # Unfiltered Events
    @_events = Event.all
    # Topics
    @topics = Topic.all

    @events.select! do |x|
      x.end_time.future? || x.end_time.today?
    end

    if params.has_key?("date")
      layout = false
      @events = @events.select do |v|
        v.date.to_datetime.strftime("%m/%d/%Y") == params['date']
      end
    end

    #print params.inspect;
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def list
    @events = Event.all

    # Show only events on a specific date
    if params.has_key?("date")
      @events = @events.select do |v|
        v.start_time.to_datetime.strftime("%m/%d/%Y") == params['date']
      end
    end

    # Show only events in the future
    if params.has_key?("future")
      @events.select! do |x|
        x.end_time.future? || x.end_time.today?
      end
    end

    # Handle search queries
    if params.has_key?("search")
      @events.select! do |x|
        x.name.downcase.include?(params['search'].downcase) || x.description.downcase.include?(params['search'].downcase)
      end
    end

    # Handle sorting by topics
    if params.has_key?("topic")
      @events.select! do |x|
        topic_exists = false
        x.topics.each do |t|
          topic_exists = true if t.name == params['topic']
        end
      end
    end


    # Respond
    if params.has_key?("date")
      layout = false
      @events = @events.select do |v|
        v.date.to_datetime.strftime("%m/%d/%Y") == params['date']
      end
    end

    #print params.inspect;

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end
