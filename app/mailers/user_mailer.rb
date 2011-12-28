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
    
    message_body = message+"\n\n-------------------\n\nPlease login to demolesson.com to respond to this request."
    
    mail(:to => @user.email, :subject => 'You have a new interview request!', :body => message_body)
  end
  
  def date_select_notification
  
  end
  
  def beta_notification(name, email, userType, beta)    
    userTypes = [ "Teacher", "Teacher Assistant", "Student", "Administrator" ]
    
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
    @passcode.save!
    
    mail(:to => email, :subject => 'Welcome to Demo Lesson!', :body => "Hi #{name}, \n\nThank you for your interest. To signup with the site click the link below:\n\n http://demolesson.com/signup?passcode=#{@passcode.code}\n\nRegards,\nDemo Lesson Team\n(323) 786-3366\ninfo@demolesson.com")
  end
  
end
