class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :creator_id
      t.integer :type
      t.integer :message_id
      t.integer :interview_id
      t.integer :application_id
      t.timestamps
    end
  end
end
