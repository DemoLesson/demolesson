class HomeController < ApplicationController
  layout 'standard'
    
  def index
    if self.current_user.nil?
      
    elsif self.current_user.school != nil
      puts "admin user"
      @jobs = Job.find(:all, :conditions => ['school_id = ?', self.current_user.school.id], :order => 'created_at DESC')
      
      @applicants = 0
      @jobs.each do |job|
        @applicants = @applicants+job.new_applicants.count
      end
      
    elsif self.current_user.teacher != nil
      @user = User.find(self.current_user.id)
      @jobs = Job.find(:all, :limit => 4, :order => 'created_at DESC')
      @interviews = Interview.find(:all, :conditions => ['teacher_id = ?', self.current_user.teacher.id])
    end
  end
  
  def about
  end
  
  def privacy
  end
  
  def terms_of_service
  end
  
  def contact
  end
  
  def how_it_works_teachers
  end
  
  def how_it_works_schools
  end
  
end
