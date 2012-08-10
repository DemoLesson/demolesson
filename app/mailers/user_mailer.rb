class UserMailer < ActionMailer::Base
  default :from => "Demo Lesson <demolesson@demolesson.com>"
  
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

  def userconnect(owner_id, user_id)
    @owner = User.find(owner_id)
    @user = User.find(user_id)

    mail(:to => @user.email, :subject => 'You have a new connection inivitation!')
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

  def refer_site_email(teachername, emails, message, user = nil)

    # Set variables for use inside the email itself
    @teachername = teachername
    @message = message

    # Get the refering ID
    @referer = user.id unless user.nil?

    # Set the subject for the email
    subject =  @teachername+' wants you to check out Demo Lesson!'

    # Send out the email
    mail(:to => emails, :subject => subject) 
  end

  def event_invite_email(teachername, emails, message, event, user = nil)

    # Set variables for use inside the email itself
    @teachername = teachername
    @message = message

    # Source the event itself
    @event = event

    # Get the refering ID
    @referer = user.id unless user.nil?

    # Set the subject for the email
    subject =  @teachername+' wants you to check out an upcoming event on Demo Lesson!'

    # Send out the email
    mail(:to => emails, :subject => subject) 
  end
  
  def school_signup_email(name, schoolname, email, phonenumber, school)
     @name = name
     @schoolname = schoolname
     @email = email
     @phonenumber = phonenumber
     
     subject =  @schoolname+' just signed up to Demo Lesson for a free trial, please contact them to discuss their free trial.'
     body = "Name:"+@name+"\n\nSchool name:"+@schoolname+"\n\nPhone Number:"+@phonenumber+"\n\nhttp://www.demolesson.com/schools/"+school.id.to_s
        
        mail(:to => 'schumacher.hodge@demolesson.com', :subject => subject, :body => body)
        mail(:to => 'support@demolesson.com', :subject => subject, :body => body)
  end
  
  def rejection_notification(teacher_id, job_id, name)  
    @teacher = Teacher.find(teacher_id)
    @job = Job.find(job_id)
    @user = User.find(@teacher.user_id)
    @school = School.find(@job.school_id)
    @admin_user = User.find(@school.owned_by)
    
    mail(:to => @user.email, :subject => 'Your application status has changed.')
  end

  def weeklyemail(teacher)
    @teacher=teacher
    #keywords for finding grades
    gradestring=["K","1","2","3","4","5","6","7","8","9","10","11","12", "elementary", "middle", "high","pre", "adult"]

    #must have emails enabled, be currently teacher
    #Still testing so emails are going to elijahgreen@gmail.com only
    tup = SmartTuple.new(" AND ")
    tup << ["jobs.created_at > ?", Date.today- 7.days]

    if teacher.seeking_location.present?
      #A loaction is a specific point in that location so a radius is needed.
      #Currently a 25 miles radius
      schools = School.near( teacher.seeking_location, 25).collect(&:id)

      #if no schools go to next teacher
      if schools.size == 0
        return
      else
        @jobs = Job.is_active.where(:school_id => schools).is_active.find(:all, :conditions => tup.compile)
      end
    else
      @jobs = Job.is_active.find(:all, :conditions => tup.compile)
    end

    if teacher.seeking_grade.present?
      jobarray = []

      #Elementary grades, K-6
      if gradestring[0..6].any? { |str| teacher.seeking_grade.include? str } || teacher.seeking_grade.downcase.include?("elementary")
        #2=elementary,7=K-6,8=K-8,10=K-12
        jobarray+=@jobs.select { |job| job.school.grades == 2 || job.school.grades == 8 || job.school.grades == 10 }
      end

      #Middle grades, 6-8 
      if gradestring[6..8].any? { |str| teacher.seeking_grade.include? str } || teacher.seeking_grade.downcase.include?("middle")
        #3=middle,8=K-8,9=6-12, 10=K-12
        jobarray+=@jobs.select { |job| job.school.grades == 3 || job.school.grades == 8 || job.school.grades == 9 || job.school.grades == 10 }
      end

      #High school grades, K-12
      if gradestring[9..12].any? { |str| teacher.seeking_grade.include? str } || teacher.seeking_grade.downcase.include?("high")
        #10=K-12, 9=6-12, 4 = high school
        jobarray+=@jobs.select { |job| job.school.grades == 9 || job.school.grades == 10 || job.school.grades == 4 }
      end

      #Pre-school
      if teacher.seeking_grade.downcase.include?("pre")
        #1=pre-K
        jobarray+=@jobs.select { |job| job.school.grades == 1 }
      end

      #Adult School
      if teacher.seeking_grade.downcase.include?("adult")
        jobarray+=@jobs.select { |job| job.school.grades == 5 }
      end

      @jobs=jobarray.uniq
    end

    if teacher.seeking_subject.present?
      #select subjects whose names is in seeking_subject
      @subjects=Subject.all.select { |subject| teacher.seeking_subject.include? subject.name }

      jobarray = []

      #any jobs with a particular subject is added to the array, because of this there are possibly duplicates
      @subjects.each do |subject|
        jobarray+=@jobs.select{ |job| JobsSubjects.find(:first, :conditions => [ "job_id = ? AND subject_id = ?", job.id, subject.id]) != nil }
      end
      #make sure that every job of the jobs array is unique
      @jobs=jobarray.uniq
    end

    if @jobs.size > 0
      mail(:to => teacher.user.email, :subject => "New job postings at demolesson.com")
    end
  end
end
