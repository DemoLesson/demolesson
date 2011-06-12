class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    create_table :subjects_teachers do |t|
      t.integer :teacher_id
      t.integer :subject_id

      t.timestamps
    end

    create_table :jobs_subjects do |t|
      t.integer :job_id
      t.integer :subject_id

      t.timestamps
    end

  end

  def self.down
    drop_table :subjects
  end
end
