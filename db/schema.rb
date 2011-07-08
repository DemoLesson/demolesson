# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110708072019) do

  create_table "alphas", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "userType"
  end

  create_table "applications", :force => true do |t|
    t.integer  "teacher_id",       :null => false
    t.integer  "job_id",           :null => false
    t.text     "additional_notes"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applications", ["job_id"], :name => "index_applications_on_job_id"
  add_index "applications", ["teacher_id"], :name => "index_applications_on_teacher_id"

  create_table "blog_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials", :force => true do |t|
    t.string   "credentialType", :null => false
    t.string   "name",           :null => false
    t.string   "issuer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials_jobs", :id => false, :force => true do |t|
    t.integer "job_id",        :null => false
    t.integer "credential_id", :null => false
  end

  add_index "credentials_jobs", ["credential_id", "job_id"], :name => "index_credentials_jobs_on_credential_id_and_job_id"
  add_index "credentials_jobs", ["job_id"], :name => "index_credentials_jobs_on_job_id"

  create_table "credentials_teachers", :id => false, :force => true do |t|
    t.integer "teacher_id",    :null => false
    t.integer "credential_id", :null => false
  end

  add_index "credentials_teachers", ["credential_id", "teacher_id"], :name => "index_credentials_teachers_on_credential_id_and_teacher_id"
  add_index "credentials_teachers", ["teacher_id"], :name => "index_credentials_teachers_on_teacher_id"

  create_table "jobs", :force => true do |t|
    t.integer  "school_id",       :null => false
    t.text     "description"
    t.string   "employment_type"
    t.string   "salary"
    t.boolean  "special_needs"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["school_id"], :name => "index_jobs_on_school_id"

  create_table "jobs_subjects", :id => false, :force => true do |t|
    t.integer "job_id",     :null => false
    t.integer "subject_id", :null => false
  end

  add_index "jobs_subjects", ["job_id"], :name => "index_jobs_subjects_on_job_id"
  add_index "jobs_subjects", ["subject_id", "job_id"], :name => "index_jobs_subjects_on_subject_id_and_job_id"

  create_table "messages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_permissions", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "job_id",  :null => false
  end

  add_index "review_permissions", ["job_id"], :name => "index_review_permissions_on_job_id"
  add_index "review_permissions", ["user_id"], :name => "index_review_permissions_on_user_id"

  create_table "reviews", :force => true do |t|
    t.integer  "application_id", :null => false
    t.integer  "reviewer_id",    :null => false
    t.string   "rating"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["application_id"], :name => "index_reviews_on_application_id"
  add_index "reviews", ["reviewer_id"], :name => "index_reviews_on_reviewer_id"

  create_table "schools", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "location"
    t.text     "description"
    t.integer  "owned_by",    :null => false
    t.float    "lng"
    t.float    "lat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["lat", "lng"], :name => "index_schools_on_lat_and_lng"
  add_index "schools", ["owned_by"], :name => "index_schools_on_owned_by"

  create_table "subjects", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", :id => false, :force => true do |t|
    t.integer "teacher_id", :null => false
    t.integer "subject_id", :null => false
  end

  add_index "subjects_teachers", ["subject_id", "teacher_id"], :name => "index_subjects_teachers_on_subject_id_and_teacher_id"
  add_index "subjects_teachers", ["teacher_id"], :name => "index_subjects_teachers_on_teacher_id"

  create_table "teachers", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.string   "resume_file"
    t.string   "location"
    t.float    "lng"
    t.float    "lat"
    t.boolean  "special_needs"
    t.boolean  "willing_to_move"
    t.boolean  "currently_seeking", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "phone"
  end

  add_index "teachers", ["lat", "lng"], :name => "index_teachers_on_lat_and_lng"
  add_index "teachers", ["user_id"], :name => "index_teachers_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "hashed_password",                        :null => false
    t.string   "salt",                                   :null => false
    t.string   "name"
    t.boolean  "is_verified",         :default => false, :null => false
    t.boolean  "is_admin",            :default => false, :null => false
    t.string   "default_home"
    t.string   "verification_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

  create_table "video_views", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "video_id",   :null => false
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_views", ["video_id"], :name => "index_video_views_on_video_id"

  create_table "videos", :force => true do |t|
    t.integer  "teacher_id",  :null => false
    t.string   "location",    :null => false
    t.string   "type"
    t.string   "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["teacher_id"], :name => "index_videos_on_teacher_id"

  create_table "winks", :force => true do |t|
    t.integer  "teacher_id", :null => false
    t.integer  "job_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "winks", ["job_id"], :name => "index_winks_on_job_id"
  add_index "winks", ["teacher_id"], :name => "index_winks_on_teacher_id"

end
