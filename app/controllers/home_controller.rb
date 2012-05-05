class HomeController < ApplicationController
  layout 'standard'
  
  USER_ID, PASSWORD = "upstartla", "incubator"
  USER_ID_M, PASSWORD_M = "muckerlab", "incubator"
  before_filter :authenticate, :only => [ :video1, :video2, :video3, :video4 ]
  before_filter :muckerlab_auth, :only => [ :muckerlab ]
    
  def index
    if self.current_user.nil?
      
    elsif self.current_user.school != nil
      puts "admin user"
      
      @jobs = []
      @schools = self.current_user.schools
      @schools.each do |school|
        @jobs_sign = Job.find(:all, :conditions => ['school_id = ? AND active = ?', school.id, true], :order => 'created_at DESC')
        @jobs = @jobs+@jobs_sign
      end
      
      @activities = Activity.find(:all, :conditions => ['user_id = ? OR user_id = 0', self.current_user.id], :order => 'created_at DESC')
      
      @applicants = 0
      @jobs.each do |job|
        @applicants = @applicants+job.new_applicants.count
      end
      
    elsif self.current_user.teacher != nil
      @user = User.find(self.current_user.id)
      @jobs = Job.find(:all, :conditions => ['active = ?', true], :limit => 4, :order => 'created_at DESC')
      @featuredjobs = Job.find(:all, :conditions => ['active = ?', true], :order => 'created_at DESC')
      @interviews = Interview.find(:all, :conditions => ['teacher_id = ?', self.current_user.teacher.id])
    end
    
    @alpha = Alpha.new
    
    respond_to do |format|
      format.html # beta.html.erb
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
  
  def video1
  end
  
  def video2
  end
  
  def video3
  end
  
  def video4
  end
  
  def muckerlab
  end
  
  def teachers_faq
   end

  def schools_faq
  end
  
  def site_referral
  end

   def site_referral_email
       @referral = params[:referral]
       @teachername = @referral[:teachername]
       @name = @referral[:name]
       @email = @referral[:email]

       UserMailer.refer_site_email(@teachername, @name, @email).deliver

        respond_to do |format|
           format.html { redirect_to "http://www.demolesson.com", :notice => 'Email Sent Successfully' }

        end
   end
  
  private
   def authenticate
        authenticate_or_request_with_http_basic do |id, password| 
        id == USER_ID && password == PASSWORD
      end
   end
  
   def muckerlab_auth
        authenticate_or_request_with_http_basic do |id, password| 
        id == USER_ID_M && password == PASSWORD_M
   end
  end
end
