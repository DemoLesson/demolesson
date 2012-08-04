class CreateSchoolAdministrators < ActiveRecord::Migration
  def change
    create_table :school_administrators do |t|
      t.integer :user_id
      t.integer :school_id
      t.integer :owner_user_id

      t.timestamps
    end
  end
end
