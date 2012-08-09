class CreateAnalyticsTable < ActiveRecord::Migration
  def up

  	# Create analytics table
    create_table :analytics do |t|

      # Collect details on what type of event happened
      t.string :slug
      t.text :message

      # What page url did this happen on
      t.string :path

      # Connect to a user if they are signed in
      t.integer :user_id

      # Tag will be a connection to another model (ex. Model:_id_)
      t.string :tag

      # Use for storing serialized data
      t.text :data

      # Time stamps for us
      t.timestamps
    end
  end

  def down
  	drop_table :analytics
  end
end
