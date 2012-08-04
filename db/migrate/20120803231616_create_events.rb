class CreateEvents < ActiveRecord::Migration
  def change

    # Create events table
    create_table :events do |t|

      # Name/Description
      t.string :name
      t.text :description
      
      # Time Frame
      t.datetime :start_time
      t.datetime :end_time
      
      # Location
      t.string :loc_name
      t.string :loc_address
      t.string :loc_address1
      t.string :loc_city
      t.string :loc_state
      t.string :loc_zip

      # Geolocation
      t.float :loc_latitude
      t.float :loc_longitude

      # Virtual Event?
      t.boolean :virtual

      # Phone Event
      t.string :virtual_phone
      t.string :virtual_phone_access

      # Web Event
      t.string :virtual_web_link
      t.string :virtual_web_access

      # TV Event
      t.string :virtual_tv_station

      # Host Organization
      t.string :host_organization
      t.string :host_organization_website

      # Public Event?
      t.boolean :public_event

      # RSVP Requirement/Dealine
      t.boolean :rsvp_req
      t.datetime :rsvp_dealine

      # Cost to attend
      t.float :attendance_cost

      # Format of event
      t.string :event_format

      # Topic
      t.string :event_topic

      # Subject(s)
      t.text :event_subject

      # Time stamps for us
      t.timestamps
    end

    add_column :users, :time_zone, :string, :limit => 255, :default => "UTC"
  end
end
