class CreateReviewPermissions < ActiveRecord::Migration
  def self.up
    create_table :review_permissions, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :job_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :review_permissions
  end
end
