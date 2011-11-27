class Interview < ActiveRecord::Base
  attr_accessible :interview_type, :location, :school_location, :message, :teacher_id, :job_id, :date, :date_alternate, :date_alternate_second, :selected
  
  def responded
    
  end
  
  def activify
    @activity = Activity.new
    @activity.user_id = School.find(Job.find(self.job_id).school_id).owned_by
    @activity.creator_id = Teacher.find(self.teacher_id).user_id
    @activity.activityType = 2
    @activity.message_id = 0
    @activity.interview_id = self.id
    @activity.application_id = Application.find(:first, :conditions => ['teacher_id = ? AND job_id = ?', self.teacher_id, self.job_id]).id
    @activity.save    
  end  
end
