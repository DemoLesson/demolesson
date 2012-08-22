class CreateRsvps < ActiveRecord::Migration
  def up
    # Create the events -> user (rsvp) connection table
    create_table :events_rsvps, :id => false do |t|
      t.column :event_id, :integer
      t.column :user_id, :integer
    end
  end

  def down
  	drop_table :events_rsvps
  end
end
