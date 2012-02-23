class UserMailer < ActionMailer::Base
  default :from => "demolesson@demolesson.com"
  
  def message_notification(user_id, subject, body, id, name)
    @user = User.find(user_id)
      
    message_body = "Hi "+@user.name+",\n\n"+name+" sent you a new message on Demo Lesson:\n\n"+body+"\n\nTo reply, click the link below:\n http://demolesson.com/messages/"+id.to_s+"\n\n-------------------\nYou received this message because you are a member of DemoLesson.com"
      
    mail(:to => @user.email,
           :subject => name+' messaged you: '+subject, :body => message_body)
  end
  
  def interview_notification(teacher_id, message)  
    @teacher = Teacher.find(teacher_id)
    @user = User.find(@teacher.user_id)
    
    message_body = "Please login to demolesson.com to respond to this request."
    
    mail(:to => @user.email, :subject => 'You have a new interview request!', :body => message_body)
  end
  
  def teacher_applied(school_id, job_id, teacher_id)
    @school = School.find(school_id)
    @admin_user = User.find(@school.owned_by)
    
    @job = Job.find(job_id)
    @teacher = Teacher.find(teacher_id)
    @teacher_user = User.find(@teacher.user_id)
    
    message_body = "Please login to demolesson.com to respond to this request."
    subject = @teacher_user.name+' applied to your job posting: '+@job.title
    
    mail(:to => @admin_user.email, :subject => subject, :body => message_body)
  end
  
  def interview_scheduled(user_id, job_id)
    @teacher_user = User.find(user_id)
    
    @job = Job.find(job_id)
    @school = School.find(@job.school_id)
    @admin_user = User.find(@school.owned_by)
    
    message_body = message+"\n\nPlease login to demolesson.com to view your interviewee's request."
    
    mail(:to => @admin_user.email, :subject => @teacher_user.name+' has scheduled an interview', :body => message_body)
  end
  
  def deliver_forgot_password(email, name, pass)
    mail(:to => email, :subject => '[DemoLesson] Password Reset', :body => "You have requested a password reset through our site. Your new password is:\n\n#{pass}\n\nPlease login and change it at your earliest convenience.\n\nRegards,\nThe Demo Lesson Team\nhttp://demolesson.com")
  end
  
  def beta_notification(name, email, userType, beta)    
    userTypes = [ "Teacher", "Teacher Assistant", "Student Teacher", "Administrator" ]
    
    betaProgram = 'Not a tester'
    if beta == true
      betaProgram = "Applied"
      if userType == 1 || userType == 2
        self.send_passcode(name, email).deliver
      end
    end
    
    mail(:to => 'demolesson@demolesson.com', :subject => '[DemoLesson] New Beta Signup', :body => "A new user has registered via the landing page.\n\nName: #{name}\nEmail: #{email}\n\nUser Type: #{userTypes[userType-1]}\nBeta Program: #{betaProgram}")
  end
  
  def send_passcode(name, email)
    @passcode = Passcode.find_by_given_out(nil)
    @passcode.given_out = true
    @passcode.sent_to = email
    @passcode.save!
    
    mail(:to => email, :subject => 'Welcome to Demo Lesson!', :body => "Hello and Welcome to Demo Lesson!\n\nWe are thrilled to give you access to our revolutionary online hiring platform and cannot wait for you to start building your very own Demo Lesson profile! Below you will find your personalized code that will grant you access to the site, as well as important terms of service you are agreeing to by signing up as a beta tester.\n\n 1) In appreciation for signing up as a beta tester, we will grant you FREE access to our site through March 31, 2012!\n\n 2) Please note that the site you are accessing is a soft launch of the site and does not represent the final product. We will add additional features in the future to optimize your experience!\n\n 3) Once you are on the site, please be sure to check out our exemplar profile page (the link is in the \"Edit Profile\" section of the site).  Also, please take the time to participate in our beta user survey, which will be emailed to you after you access the platform.\n\n 4) By clicking on the link below, you agree that this is a private and individual code for beta-testing purposes and that it is NOT TO BE SHARED with others. By clicking on the link below, you will gain access to the site, and be directed to create your personal url:\n\nhttp://demolesson.com/signup?passcode=#{@passcode.code}\n\nIf you have any questions or need additional support please contact us at support@demolesson.com.\n\nAgain, welcome to Demo Lesson! We look forward to working with you to meet all your job searching needs!\n\nThe Demo Lesson Team\n(323) 786-3366\ninfo@demolesson.com")
  end
end
