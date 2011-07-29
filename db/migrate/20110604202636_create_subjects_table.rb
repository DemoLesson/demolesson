class CreateSubjectsTable < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :name, :null => false
      t.string :description

      t.timestamps
    end

    create_table :subjects_teachers, :id => false do |t|
      t.integer :teacher_id, :null => false
      t.integer :subject_id, :null => false

      t.timestamps
    end

    create_table :jobs_subjects, :id => false do |t|
      t.integer :job_id, :null => false
      t.integer :subject_id, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :subjects
  end
end
