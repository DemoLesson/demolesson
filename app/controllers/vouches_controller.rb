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
        @vouch.update_attribute(:url, vouchinfo+@vouch.id.to_s)
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
    redirect_to :root, :notice => "Success"
  end

  def vouchresponse
    @vouch = Vouch.find(:first, :conditions =>["url = ?", params[:u]])
    @user=@vouch.vouchee
    @vouchedskills = @user.vouched_skills.collect(&:skill_group_id)
    @skills=SkillGroup.all
    @userskills=@user.skill_groups
  end

  def unlocked
    @user = User.find(:first, :conditions => ['email = ?', params[:user][:email]])
    if @user != nil && params[:urlstring] != nil
      if @user.teacher != nil
          @vouch=Vouch.find(:first, :conditions => ['url = ?', params[:urlstring]])
          @vouch.new_teacher_skills.each do |skill|
            VouchedSkill.create(:user_id => @user.id, :skill_group_id => skill.skill_group_id)
          end
      end
      redirect_to '/vouchrequest?u=' + params[:urlstring]
    elsif @user != nil
      redirect_to :root, :notice => "There is already an account with this email address."
    else
      password=User.random_string(10)
      params[:user][:password]=password
      params[:user][:confirm_password]=password
      @user = User.new(params[:user])
      if @user.save
        @user.create_teacher
        UserMailer.teacher_welcome_email_temppassword(@user.id, password).deliver
        session[:user] = User.authenticate(@user.email, @user.password)
        if params[:urlstring]
          @vouch=Vouch.find(:first, :conditions => ['url = ?', params[:urlstring]])
          @vouch.new_teacher_skills.each do |skill|
            VouchedSkill.create(:user_id => @user.id, :skill_group_id => skill.skill_group_id)
          end
          redirect_to '/vouchresponse?u=' + params[:urlstring]
        else
          redirect_to '/card/'+ @user.teacher.url
        end
      else 
        redirect_to :root, :notice => @user.errors.full_messages.to_sentence
      end
    end
  end
end
