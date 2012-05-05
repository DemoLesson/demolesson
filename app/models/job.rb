class Job < ActiveRecord::Base
  belongs_to :school
  
  has_and_belongs_to_many :credentials
  has_and_belongs_to_many :subjects
  
  has_many :applications
  has_many :winks
  
  reverse_geocoded_by :latitude, :longitude
  
  scope :is_active, where(:active => true)
  
  #scope :dry_clean_only, joins(:washing_instructions).where('washing_instructions.dry_clean_only = ?', true)
  
  scoped_search :on => [:title, :description]
  
  self.per_page = 15
  
  #searchable do 
  #  text :description, :title
  #end
  
  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
  
  def school
    @school = School.find(self.school_id)
    return @school
  end
  
  def subjects
    @subjects = JobsSubjects.find(:all, :conditions => ['job_id = ?', self.id])
    return @subjects
  end
  
  def update_subjects(subjects)
    JobsSubjects.delete_all(["job_id = ?", self.id])
    
    subjects.each do |subject|
      @jobs_subjects = JobsSubjects.new
      @jobs_subjects.job_id = self.id
      @jobs_subjects.subject_id = subject.to_i
      @jobs_subjects.save
    end
  end
  
  def zipcode
    return self.school.map_zip
  end
  
  def apply(teacher_id)
    @application = Application.find(:first, :conditions => ['job_id = ? AND teacher_id = ?', self.id, teacher_id])
    if @application == nil
      @application = Application.create!(:job_id => self.id, :teacher_id => teacher_id, :status => 1, :viewed => 0)
      UserMailer.teacher_applied(self.school_id, self.id, teacher_id).deliver
      @application.activify
    else
      @application.deactivify
      @application.destroy
    end
  end
  
  def applicants
    @applicants = Application.find(:all, :conditions => ['job_id = ?', self.id])
    return @applicants
  end
  
  def new_applicants
    @applicants = Application.find(:all, :conditions => ['job_id = ? AND viewed = ?', self.id, false])
  end
  
  def belongs_to_me(user)
    @school = School.find(self.school)
    belongs = false
    if @school != nil
      if user.id == @school.owned_by
        belongs = true
      end
    end
    return belongs
  end
  
  def cleanup
    @applications = Application.find(:all, :conditions => ['job_id = ?', self.id])
    @applications.each do |application|
      @activity = Activity.find(:all, :conditions => ['application_id = ?', application.id])
      @activity.destroy
    end
    @applications.map(&:destroy)
  end
  
end
