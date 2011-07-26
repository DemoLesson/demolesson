class IncreaseMsgLength < ActiveRecord::Migration
  def up
    change_column :messages, :body, :string, :limit => 10000
  end

  def down
  end
end