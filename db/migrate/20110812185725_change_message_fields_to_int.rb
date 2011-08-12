class ChangeMessageFieldsToInt < ActiveRecord::Migration
  def up
    change_column :messages, :user_id_from, :integer
    change_column :messages, :user_id_to, :integer
  end

  def down
  end
end