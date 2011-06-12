class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :application_id
      t.integer :reviewer_id
      t.string :rating
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
