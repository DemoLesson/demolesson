class Job < ActiveRecord::Base
  belongs_to :school
  
  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects
  
  has_many :applications
  has_many :winks
  
  self.per_page = 15
  
  def school
    @school = School.find(self.school_id)
    return @school
  end
  
  def subjects
    @subjects = JobsSubjects.find(:all, :conditions => ['job_id = ?', self.id])
    return @subjects
  end
  
end
