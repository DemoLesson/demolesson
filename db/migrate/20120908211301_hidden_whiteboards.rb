class HiddenWhiteboards < ActiveRecord::Migration
  def up
    # Create the events -> user (rsvp) connection table
    create_table :whiteboards_hidden, :id => false do |t|
      t.column :whiteboard_id, :integer
      t.column :user_id, :integer
    end
  end

  def down
  	drop_table :whiteboards_hidden
  end
end
