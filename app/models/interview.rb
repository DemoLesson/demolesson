class Interview < ActiveRecord::Base
  attr_accessible :interview_type, :location, :school_location, :message, :teacher_id, :job_id, :date, :date_alternate, :date_alternate_second
end
