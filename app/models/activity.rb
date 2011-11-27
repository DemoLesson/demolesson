class Activity < ActiveRecord::Base
  attr_accessible :user_id, :creator_id, :activityType, :message_id, :interview_id, :application_id
  
  def creator
    @user = User.find_by_id(self.creator_id)
    return @user
  end
  
  def teacher
    @teacher = Teacher.find_by_user_id(self.creator_id)
    return @teacher
  end
  
  def application_job
    @application = Application.find(self.application_id)
    @job = Job.find(@application.job_id)
    return @job
  end
  
  def application_school
    @application = Application.find(self.application_id)
    @job = Job.find(@application.job_id)
    @school = School.find(@job.school_id)
    return @school
  end
  
  def interview
    @interview = Interview.find(self.interview_id)
    return @interview
  end
  
  def message
    @message = Message.find(self.message_id)
    return @message
  end
  
end
