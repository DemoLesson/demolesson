class CreateStars < ActiveRecord::Migration
  def self.up
    create_table :stars do |t|
      t.integer 'teacher_id'
      t.integer 'voter_id'
    end
  end

  def self.down
    drop_table :stars
  end
end