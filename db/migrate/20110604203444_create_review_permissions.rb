class CreateReviewPermissions < ActiveRecord::Migration
  def self.up
    create_table :review_permissions do |t|
      t.integer :user_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :review_permissions
  end
end
