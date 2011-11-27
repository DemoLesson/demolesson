class ActivitiesChangeType < ActiveRecord::Migration
  def up
    rename_column :activities, :type, :activityType
  end

  def down
  end
end