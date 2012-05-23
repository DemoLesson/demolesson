class CreateSharedUsers < ActiveRecord::Migration
  def change
    create_table :shared_users do |t|
      t.integer :owned_by
      t.integer :user_id

      t.timestamps
    end
  end
end
