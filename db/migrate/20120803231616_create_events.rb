class CreateEvents < ActiveRecord::Migration
  def change

    # Create events table
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.text :description
      t.string :location
      t.text :subject

      t.timestamps
    end

    add_column :users, :time_zone, :string, :limit => 255, :default => "UTC"
  end
end
