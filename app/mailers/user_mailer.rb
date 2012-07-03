class UserMailer < ActionMailer::Base
  default :from => "demolesson@demolesson.com"
  
  def teacher_welcome_email(user_id)
    @user = User.find(user_id)
    @teacher = Teacher.find_by_user_id(user_id)
    
    mail(:to => @user.email, :subject => 'Welcome to DemoLesson!')
  end
  
  def message_notification(user_id, subject, body, id, name)
    @user = User.find(user_id)
    @subject = subject
    @message_body = body[0,140]
    @id = id
    @sender_name = name
      
    mail(:to => @user.email, :subject => name+' messaged you: '+subject)
  end
  
  def interview_notification(teacher_id, job_id)  
    @teacher = Teacher.find(teacher_id)
    @user = User.find(@teacher.user_id)
    @job = Job.find(job_id)
    
    mail(:to => @user.email, :subject => 'You have a new interview request!')
  end
  
  def teacher_applied(school_id, job_id, teacher_id)
    @school = School.find(school_id)
    @admin_user = User.find(@school.owned_by)
    
    @job = Job.find(job_id)
    @teacher = Teacher.find(teacher_id)
    @teacher_user = User.find(@teacher.user_id)
    
    message_body = "Please login to demolesson.com to respond to this request."
    subject = @teacher_user.name+' applied to your job posting: '+@job.title
    
    mail(:to => @admin_user.email, :subject => subject)

    @admins = SharedUsers.find(:all, :conditions => { :owned_by => @admin_user.id })
    @admins.each do |admin|
      shared =User.find(admin.user_id)
      if shared.is_limited ==false
        mail(:to => shared.email, :subject => subject)
      end
    end

    @limitedusers = SharedSchool.find(:all, :conditions => { :school_id => @school.id})
    @limitedusers.each do |limiteduser|
      shared = User.find(limiteduser.user_id)
      mail(:to => shared.email, :subject => subject)
    end
  end
  
  def interview_scheduled(user_id, job_id)
    @teacher_user = User.find(user_id)
    
    @job = Job.find(job_id)
    @school = School.find(@job.school_id)
    @admin_user = User.find(@school.owned_by)
    
    message_body = "Please login to demolesson.com to view your interviewee's request."
    
    mail(:to => @admin_user.email, :subject => @teacher_user.name+' has scheduled an interview', :body => message_body)

    @admins = SharedUsers.find(:all, :conditions => { :owned_by => @admin_user.id })
    @admins.each do |admin|
      shared =User.find(admin.user_id)
      if shared.is_limited ==false
        mail(:to => shared.email, :subject => @teacher_user.name+' has scheduled an interview', :body => message_body)
      end
    end

    @limitedusers = SharedSchool.find(:all, :conditions => { :school_id => @school.id})
    @limitedusers.each do |limiteduser|
      shared = User.find(limiteduser.user_id)
      mail(:to => shared.email, :subject => @teacher_user.name+' has scheduled an interview', :body => message_body)
    end
  end
  
  def deliver_forgot_password(email, name, pass)
    mail(:to => email, :subject => '[DemoLesson] Password Reset', :body => "You have requested a password reset through our site. Your new password is:\n\n#{pass}\n\nPlease login and change it at your earliest convenience.\n\nRegards,\nThe Demo Lesson Team\nhttp://demolesson.com")
  end
  
  def send_passcode(name, email)
    @passcode = Passcode.find_by_given_out(nil)
    @passcode.given_out = true
    @passcode.sent_to = email
    @passcode.save!
    
    mail(:to => email, :subject => 'Welcome to Demo Lesson!', :body => "Hello and Welcome to Demo Lesson!\n\nWe are thrilled to give you access to our revolutionary online hiring platform and cannot wait for you to start building your very own Demo Lesson profile! Below you will find your personalized code that will grant you access to the site, as well as important terms of service you are agreeing to by signing up as a beta tester.\n\n 1) In appreciation for signing up as a beta tester, we will grant you FREE access to our site through March 31, 2012!\n\n 2) Please note that the site you are accessing is a soft launch of the site and does not represent the final product. We will add additional features in the future to optimize your experience!\n\n 3) Once you are on the site, please be sure to check out our exemplar profile page (the link is in the \"Edit Profile\" section of the site).  Also, please take the time to participate in our beta user survey, which will be emailed to you after you access the platform.\n\n 4) By clicking on the link below, you agree that this is a private and individual code for beta-testing purposes and that it is NOT TO BE SHARED with others. By clicking on the link below, you will gain access to the site, and be directed to create your personal url:\n\nhttp://demolesson.com/signup?passcode=#{@passcode.code}\n\nIf you have any questions or need additional support please contact us at support@demolesson.com.\n\nAgain, welcome to Demo Lesson! We look forward to working with you to meet all your job searching needs!\n\nThe Demo Lesson Team\n(323) 786-3366\ninfo@demolesson.com")
  end

  # INTERNAL
  def beta_notification(name, email, userType, beta)    
    userTypes = [ "Teacher", "Teacher Assistant", "Student Teacher", "Administrator" ]
  
    betaProgram = 'Not a tester'
    if beta == true
      betaProgram = "Applied"
      if userType == 1 || userType == 2 || userType == 3
        self.send_passcode(name, email).deliver
      end
    end
  
    mail(:to => 'demolesson@demolesson.com', :subject => '[DemoLesson] New Beta Signup', :body => "A new user has registered via the landing page.\n\nName: #{name}\nEmail: #{email}\n\nUser Type: #{userTypes[userType-1]}\nBeta Program: #{betaProgram}")
  end
  
  def refer_job_email(teachername, job_id, name, email)
     @job = Job.find(job_id)
     @name = name
     @teachername = teachername
     
     subject =  @teachername+' has referred you to a job, '+@job.title+' on Demo Lesson!!'
        
        mail(:to => email, :subject => subject) 
        #:body => "Hi #{name}! "+@teacher_user.name+" wants you too check out the job, "+@job.title+", posted by "+@job.school.name+" on Demo Lesson! Click on the following link to view the job posting: http://www.demolesson.com/jobs/#{@job.id}\n\nIf you have any questions or need additional support please contact us at support@demolesson.com.")
        
  end

  def refer_site_email(teachername, name, email)
     @name = name
     @teachername = teachername
     
     subject =  @teachername+' wants you to check out Demo Lesson!!'
        
        mail(:to => email, :subject => subject)
        
  end
  
  def school_signup_email(name, schoolname, email, phonenumber)
     @name = name
     @schoolname = schoolname
     @email = email
     @phonenumber = phonenumber
     
     subject =  @schoolname+' just signed up to Demo Lesson!!'
        
        mail(:to => 'schumacher.hodge@demolesson.com', :subject => subject)
        
  end
  
  def rejection_notification(teacher_id, job_id, name)  
    @teacher = Teacher.find(teacher_id)
    @job = Job.find(job_id)
    @user = User.find(@teacher.user_id)
    @school = School.find(@job.school_id)
    @admin_user = User.find(@school.owned_by)
    
    mail(:to => @user.email, :subject => 'Your application status has changed')
  end
end
