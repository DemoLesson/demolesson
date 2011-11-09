class Job < ActiveRecord::Base
  belongs_to :school
  
  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects
  
  has_many :applications
  has_many :winks
  
  scope :is_active, where(:active => true)
  
  #scope :dry_clean_only, joins(:washing_instructions).where('washing_instructions.dry_clean_only = ?', true)
  
  scoped_search :on => [:title, :description]
  
  self.per_page = 15
  
  def school
    @school = School.find(self.school_id)
    return @school
  end
  
  def subjects
    @subjects = JobsSubjects.find(:all, :conditions => ['job_id = ?', self.id])
    return @subjects
  end
  
  def zipcode
    return self.school.map_zip
  end
  
  def apply(teacher_id)
    @application = Application.find(:first, :conditions => ['job_id = ? AND teacher_id = ?', self.id, teacher_id])
    if @application == nil
      @application = Application.new
      @application.job_id = self.id
      @application.teacher_id = teacher_id
      @application.status = 1
      @application.save
    else
      @application.destroy
    end
  end
  
  def applicants
    @applicants = Application.find(:all, :conditions => ['job_id = ?', self.id])
    return @applicants
  end
  
  def belongs_to_me(user)
    @school = user.school
    belongs = 0
    if @school != nil
      if self.school_id == @school.id
        belongs = 1
      end
    end
    return belongs
  end
  
end