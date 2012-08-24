class CreateConnectionInvites < ActiveRecord::Migration
  def change
    create_table :connection_invites do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :user_id
      t.boolean :pending, :default => true
      t.string :url

      t.timestamps
    end
  end
end
