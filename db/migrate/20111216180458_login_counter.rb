class LoginCounter < ActiveRecord::Migration
  def up
    add_column :users, :login_count, :integer, :default => 0
    add_column :users, :last_login, :datetime
  end

  def down
  end
end
