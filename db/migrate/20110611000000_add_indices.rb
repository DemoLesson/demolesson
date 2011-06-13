class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :reviews, :reviewer_id
    add_index :reviews, :application_id
    add_index  :subjects_teachers, [:teacher_id]
    add_index  :subjects_teachers, [:subject_id, :teacher_id]
    add_index  :jobs_subjects, [:job_id]
    add_index  :jobs_subjects, [:subject_id, :job_id]
    add_index  :credentials_teachers, [:teacher_id]
    add_index  :credentials_teachers, [:credential_id, :teacher_id]
    add_index  :credentials_jobs, [:job_id]
    add_index  :credentials_jobs, [:credential_id, :job_id]
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
    add_index :applications, :teacher_id
    add_index :applications, :job_id
    add_index :winks, :teacher_id
    add_index :winks, :job_id
  end

  def self.down
    remove_index :reviews, :reviewer_id
    remove_index :reviews, :application_id
    remove_index  :subjects_teachers, [:teacher_id]
    remove_index  :subjects_teachers, [:subject_id, :teacher_id]
    remove_index  :jobs_subjects, [:job_id]
    remove_index  :jobs_subjects, [:subject_id, :job_id]
    remove_index  :credentials_teachers, [:teacher_id]
    remove_index  :credentials_teachers, [:credential_id, :teacher_id]
    remove_index  :credentials_jobs, [:job_id]
    remove_index  :credentials_jobs, [:credential_id, :job_id]
    remove_index  :teachers, [:lat, :lng]
    remove_index  :schools, [:lat, :lng]
    remove_index :users, :email
    remove_index :schools, :owned_by
    remove_index :teachers, :user_id
    remove_index :videos, :teacher_id
    remove_index :video_views, :video_id
    remove_index :jobs, :school_id
    remove_index :review_permissions, :user_id
    remove_index :review_permissions, :job_id
    remove_index :applications, :teacher_id
    remove_index :applications, :job_id
    remove_index :winks, :teacher_id
    remove_index :winks, :job_id
  end
end
