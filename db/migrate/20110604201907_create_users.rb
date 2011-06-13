class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :hashed_password, :null => false
      t.string :salt, :null => false
      t.string :name
      t.boolean :is_verified, :default => false, :null => false
      t.boolean :is_admin, :default => false, :null => false
      t.string :default_home
      t.string :verification_code

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
