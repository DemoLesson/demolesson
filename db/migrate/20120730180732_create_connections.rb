class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :owned_by
      t.integer :user_id
      t.boolean :pending, :default => true

      t.timestamps
    end
  end
end
