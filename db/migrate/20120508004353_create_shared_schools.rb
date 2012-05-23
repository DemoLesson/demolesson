class CreateSharedSchools < ActiveRecord::Migration
  def change
    create_table :shared_schools do |t|
      t.integer :owned_by
      t.integer :school_id
      t.integer :user_id

      t.timestamps
    end
  end
end
