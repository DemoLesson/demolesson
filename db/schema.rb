# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120326051957) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "creator_id"
    t.integer  "activityType"
    t.integer  "message_id"
    t.integer  "interview_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "blog_url"
    t.string   "blog_title"
  end

  create_table "alphas", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "userType"
    t.string   "name"
    t.boolean  "beta"
  end

  create_table "applications", :force => true do |t|
    t.integer  "teacher_id",       :null => false
    t.integer  "job_id",           :null => false
    t.text     "additional_notes"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewed"
  end

  add_index "applications", ["job_id"], :name => "index_applications_on_job_id"
  add_index "applications", ["teacher_id"], :name => "index_applications_on_teacher_id"

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "teacher_id"
  end

  create_table "blog_entries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "content"
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

  create_table "educations", :force => true do |t|
    t.string   "school"
    t.string   "degree"
    t.string   "concentrations"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
  end

  create_table "experiences", :force => true do |t|
    t.string   "company"
    t.string   "position"
    t.string   "description", :limit => 10000
    t.integer  "startMonth"
    t.integer  "startYear"
    t.integer  "endMonth"
    t.integer  "endYear"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
  end

  create_table "interviews", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_id"
    t.integer  "job_id"
    t.datetime "date"
    t.datetime "date_alternate"
    t.datetime "date_alternate_second"
    t.integer  "selected",              :default => 0
    t.integer  "interview_type"
    t.boolean  "school_location"
    t.string   "location"
    t.text     "message"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "school_id",                              :null => false
    t.text     "description"
    t.integer  "employment_type"
    t.string   "salary"
    t.boolean  "special_needs"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "multiple_subject"
    t.integer  "bilingual"
    t.integer  "experience_years"
    t.integer  "education_level"
    t.datetime "start_date"
    t.boolean  "active",              :default => true
    t.integer  "grade_level"
    t.integer  "credential_type"
    t.integer  "years_of_experience"
    t.boolean  "rolling_deadline",    :default => false
    t.string   "passcode"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "jobs", ["school_id"], :name => "index_jobs_on_school_id"

  create_table "jobs_subjects", :id => false, :force => true do |t|
    t.integer "job_id",     :null => false
    t.integer "subject_id", :null => false
  end

  add_index "jobs_subjects", ["job_id"], :name => "index_jobs_subjects_on_job_id"
  add_index "jobs_subjects", ["subject_id", "job_id"], :name => "index_jobs_subjects_on_subject_id_and_job_id"

  create_table "login_tokens", :force => true do |t|
    t.integer  "user_id"
    t.datetime "expires_at"
    t.string   "token_value", :limit => 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "login_tokens", ["user_id"], :name => "index_login_tokens_on_user_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "user_id_from"
    t.integer  "user_id_to"
    t.string   "subject"
    t.string   "body",         :limit => 10000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read"
  end

  create_table "passcodes", :force => true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "given_out"
    t.string   "sent_to"
  end

  create_table "pins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "teacher_id"
    t.integer  "job_id"
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
    t.string   "name"
    t.string   "location"
    t.text     "description"
    t.integer  "owned_by",                                               :null => false
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "district"
    t.string   "representative_title"
    t.string   "map_address"
    t.string   "map_city"
    t.integer  "map_state"
    t.integer  "map_zip"
    t.string   "phone"
    t.string   "fax"
    t.integer  "school_type"
    t.integer  "grades"
    t.string   "students_count",       :limit => 25
    t.string   "api_ayp_scores"
    t.integer  "calendar"
    t.string   "mission",              :limit => 1000
    t.string   "highlights",           :limit => 1000
    t.boolean  "gmaps"
    t.string   "website"
    t.string   "greatschools"
    t.string   "linkedin"
    t.string   "facebook"
    t.boolean  "show_personal_info",                   :default => true
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "schools", ["latitude", "longitude"], :name => "index_schools_on_lat_and_lng"
  add_index "schools", ["owned_by"], :name => "index_schools_on_owned_by"

  create_table "stars", :force => true do |t|
    t.integer "teacher_id"
    t.integer "voter_id"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name",       :null => false
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
    t.integer  "user_id",                                                   :null => false
    t.boolean  "special_needs"
    t.boolean  "willing_to_move"
    t.boolean  "currently_seeking",                       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.string   "phone"
    t.string   "position"
    t.string   "school"
    t.string   "location"
    t.string   "seeking_subject"
    t.string   "seeking_grade"
    t.string   "seeking_location"
    t.string   "additional_information", :limit => 10000
    t.string   "linkedin"
    t.string   "guest_code"
  end

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
    t.integer  "login_count",         :default => 0
    t.datetime "last_login"
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
    t.integer  "teacher_id",                                      :null => false
    t.string   "video_id",                                        :null => false
    t.string   "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secret_url"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "job_id"
    t.string   "encoded_state",          :default => "unencoded"
    t.string   "output_url"
    t.integer  "duration_in_ms"
    t.string   "aspect_ratio"
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
