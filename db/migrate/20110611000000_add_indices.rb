class AddIndices < ActiveRecord::Migration
  def self.up
    add_index  :subjects_teachers, [:teacher_id]
    add_index  :subjects_teachers, [:subject_id, :teacher_id]
    add_index  :jobs_subjects, [:job_id]
    add_index  :jobs_subjects, [:subject_id, :job_id]
    add_index  :teachers, [:lat, :lng]
    add_index  :schools, [:lat, :lng]
    add_index :users, :email
    add_index :schools, :owned_by
    add_index :teachers, :user_id
    add_index :videos, :teacher_id
    add_index :video_views, :video_id
    add_index :jobs, :school_id
    add_index :review_permissions, :user_id
    add_index :review_permissions, :job_id
    add_index :applications, :user_id
    add_index :applications, :job_id
    add_index :reviews, :user_id
    add_index :reviews, :application_id
  end

  def self.down
  end
end
