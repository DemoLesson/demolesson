class VouchesController < ApplicationController

  def vouchrequest
    user = User.find(:first, :conditions => ["email = ?", params[:vouch][:email]])
    @vouch = Vouch.new(params[:vouch])
    @vouch.vouchee_id= self.current_user.id
    #using a random string + the user_id and vouch_id to create a unique address
    vouchinfo=User.random_string(20)
    if not params[:is_teacher]
      #Just request email
      if @vouch.save
        @vouch.update_attribute(:url, vouchinfo+@vouch.id.to_s )
        url="http://#{request.host_with_port}/vouchresponse?u=" + @vouch.url
        UserMailer.vouch_request(self.current_user.name, @vouch.first_name, params[:vouch][:email],url).deliver
        redirect_to '/card/'+self.current_user.teacher.url
      else
        redirect_to '/card/'+self.current_user.teacher.url, :notice => @vouch.errors.full_messages.to_sentence
      end
    elsif user != nil
      #Send a vouch request email
      if @vouch.save
        params[:skill_groups].each do |skill|
          NewTeacherSkill.create(:vouch_id => @vouch.id, :skill_group_id => skill)
          VouchedSkill.create(:user_id => user.id, :skill_group_id => skill )
        end
        @vouch.update_attribute(:url, vouchinfo+@vouch.id.to_s)
        url="http://#{request.host_with_port}/vouchresponse?u=" + @vouch.url
        UserMailer.vouch_request(self.current_user.name, @vouch.first_name, params[:vouch][:email],url).deliver
        redirect_to '/card/'+self.current_user.teacher.url
      else
        redirect_to '/card/'+self.current_user.teacher_url, :notice => @vouch.errors.full_messages.to_sentence
      end
    else
      #Person is teacher without an account with demolesson
      if @vouch.save
        params[:skill_groups].each do |skill|
          NewTeacherSkill.create(:vouch_id => @vouch.id, :skill_group_id => skill)
        end
        @vouch.update_attribute(:url, vouchinfo+@vouch.id.to_s)
        url="http://#{request.host_with_port}/card?u=" + @vouch.url
        UserMailer.vouch_request(self.current_user.name, @vouch.first_name, params[:vouch][:email], url).deliver
        redirect_to '/card/'+self.current_user.teacher.url
      else
        redirect_to '/card/'+self.current_user.teacher.url, :notice => @vouch.errors.full_messages.to_sentence
      end
    end
  end

  def updatevouch
    @vouch=Vouch.find(:last, :conditions => ["url = ?", params[:url]])
    @vouch.update_attributes(params[:vouch])
    params[:skill_group_ids].each do |skill|
      VouchedSkill.create(:user_id=> @vouch.vouchee_id, :skill_group_id => skill, :vouch_id => @vouch.id)
    end
    @vouch.update_attribute(:pending, false)
    redirect_to :root, :notice => "Success"
  end

  def vouchresponse
    @vouch = Vouch.find(:first, :conditions =>["url = ?", params[:u]])
    if @vouch.pending == true
      @user=@vouch.vouchee
      @vouchedskills = @user.vouched_skills.collect(&:skill_group_id)
      @skills=SkillGroup.all
      @userskills=@user.skill_groups
    else
      redirect_to :root, :notice => "This voucher has already been submitted."
    end
  end

  def unlocked
    # Get a user by looking for the email
    @user = User.find(:first, :conditions => ['email = ?', params[:user][:email]])

    # If the user exists and GET ?urlstring does exist
    if @user != nil && params[:urlstring] != nil

      # If the user has a teacher
      if @user.teacher != nil

        # Find the vouch matching the urlstring
        @vouch = Vouch.find(:first, :conditions => ['url = ?', params[:urlstring]])

        # For the the (new?) teacher loop through the skills
        @vouch.new_teacher_skills.each do |skill|

          # Create a vouched skill for each skill in the loop and attach it to the user
          VouchedSkill.create(:user_id => @user.id, :skill_group_id => skill.skill_group_id)
        end
      end

      # Redirect to Vouch Request
      redirect_to '/vouchrequest?u=' + params[:urlstring]

    # If the user does exist and GET ?invitestring does exist
    elsif @user != nil && params[:invitestring] != nil

      # If the user has a teacher
      if @user.teacher != nil

        # Get the invite by the invitestring
        @invite = ConnectionInvite.find(:first, :conditions => ['url = ?', params[:invitestring]])

        # If no longer pending simply don't create any connections
        if @invite.pending

          # Create two connections
          Connection.create(:owned_by => @user.id, :user_id => @invite.user_id, :pending => false)
          Connection.create(:owned_by => @invite.user_id, :user_id => @user.id, :pending => false)

          # Create two activity logs
          #Activity.create(:creator_id => @connection.user_id, :user_id => @connection.owned_by, :activityType => 10)
          #Activity.create(:creator_id => @connection.owned_by, :user_id => @connection.user_id, :activityType => 10)

          # Insert whiteboard log here
          # Requires a logged in user though

          # Set the invite to completed
          @invite.update_attribute(:pending, false)

          # Redirect to the new users card url
          redirect_to '/card/'+ @user.teacher.url
        end
      end

    # There is already an account with this email
    # WAIT! If the above two conditions in this chain also require a user to exist.
    # Possible security hole?
    elsif @user != nil
      redirect_to :back, :notice => "There is already an account with this email address."

    # If no user exists
    else
      # Generate a random string (For a password)
      password = User.random_string(10)
      params[:user][:password] = password
      params[:user][:confirm_password] = password

      # Generate a new user with the random password
      @user = User.new(params[:user])

      # If the user saved
      if @user.save

        # Create a teacher on the user
        @user.create_teacher

        # Send out the teacher welcome email with the temp password
        UserMailer.teacher_welcome_email_temppassword(@user.id, password).deliver

        # Authenticate the user and set it to the session
        session[:user] = User.authenticate(@user.email, @user.password)

        # If urlstring was provided
        if params[:urlstring]

          # Fild a vouch matching urlstring
          @vouch=Vouch.find(:first, :conditions => ['url = ?', params[:urlstring]])

          # Loop through the skills attached to the vouch
          @vouch.new_teacher_skills.each do |skill|

            # Create a vouched skill on the user
            VouchedSkill.create(:user_id => @user.id, :skill_group_id => skill.skill_group_id)
          end

          # Redirect to to vouch response?
          redirect_to '/vouchresponse?u=' + params[:urlstring]

        # If invitestring was provided
        elsif params[:invitestring]

          # Find the invite
          @invite=ConnectionInvite.find(:first, :conditions => ['url = ?', params[:invitestring]])

          # If no longer pending simply don't create any connections
          if @invite.pending

            # Create two connections
            Connection.create(:owned_by => @user.id, :user_id => @invite.user_id, :pending => false)
            Connection.create(:owned_by => @invite.user_id, :user_id => @user.id, :pending => false)

            # Create two activities
            #Activity. create(:creator_id => @invite.user_id, :user_id => @user.id, :activityType => 10)
            #Activity.create(:creator_id => @user.id, :user_id => @invite.user_id, :activityType => 10)

            # Put in the whiteboard insert here

            # Set the invite to no longer pending
            @invite.update_attribute(:pending, false)

            # Redirect to the users card profile
            redirect_to '/card/'+ @user.teacher.url
          end

        # If user_connection is provided attemp to make the connection
        elsif params[:user_connection]

          # Redirect to the connection handler
          redirect_to :controller => :connections, :action => :add_connection, :user_id => params[:user_connection]
        else

          # Redirect to the card profile
          redirect_to '/card/'+ @user.teacher.url
        end
      else 
        
        # Redirect to the last visited page and show all the errors
        redirect_to :back, :notice => @user.errors.full_messages.to_sentence
      end
    end
  end
end
