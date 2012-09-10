class CardController < ApplicationController
  def get

    # If we have a url then load the teacher by that url
    if params[:url]
      @teacher = Teacher.find_by_url(params[:url])

      # By default lets assume that we are viewing someone elses profile
      @is_self = false

      # Are we viewing out own card (Only check if someone is logged in)
      @is_self = true if !self.current_user.nil? && @teacher == self.current_user.teacher
    else
      # If we don't have a url then set teacher to nil
      # Probabbly should load the currently logged in teachers card if they have one
      # If they don't have one then it should load a create a card right now it's allowing me to completely
      # Destroy my existing and create a new card
      @teacher = nil
      @is_self = false
    end

    # Log the card view unless you are viewing your own card
    self.log_analytic(:view_teacher_card, "Someone viewed a teacher card", @teacher) unless @is_self

    if @teacher
      @connections= @teacher.user.connections.not_pending.count
      @video = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC')
    end
    # If the video is not nil then load it
    if @video == nil
      @video = Video.new
    else
      begin
        if @video.encoded_state == 'queued'
          Zencoder.api_key = 'ebbcf62dc3d33b40a9ac99e623328583'
          @status = Zencoder::Job.progress(@video.job_id)
          if @status.body['outputs'][0]['state'] == 'finished'
            @video.encoded_state = 'finished'
            @video.save
            @embed_code = @teacher.vjs_embed_code(@video.output_url)
          else
            @embed_code = @teacher.no_embed_code
          end
        else 
          @embed_code = @teacher.vjs_embed_code(@video.output_url)
        end
      rescue
        @embed_code = @teacher.no_embed_code
      end
    end

    @credential=Credential.new
    @vouch=Vouch.new

    @uploader = Video.new.video
    @uploader.success_action_redirect = new_video_url
    if params[:u]
      @vouch = Vouch.find(:first, :conditions => ['url = ?', params[:u]])
      if @vouch.pending == false && params[:url]
        redirect_to "/card/#{params[:url]}", :notice => "This voucher has already been submitted."
      end
    elsif params[:i]
      @invite = ConnectionInvite.find(:first, :conditions => ['url = ?', params[:i]])
    end
  end

  def cardavatar
    @user=self.current_user
    respond_to do |format|
      if @user.update_attribute(:avatar, params[:user][:avatar])
        format.html { redirect_to('/change_picture') }
      end
    end
  end

  def addEducation
    @teacher = Teacher.find(self.current_user.teacher.id)
    education=@teacher.educations.build(params[:education])
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to '/card/'+@teacher.url }
      else
        format.html { redirect_to '/card/'+@teacher.url, :notice => education.errors.full_messages.to_sentence }
      end 
    end
  end

  def addCredential

    @credential = Credential.new(params[:credential])

    respond_to do |format|
      if @credential.save
        if self.current_user.teacher != nil
          @credentialsTeachers = CredentialsTeachers.new
          @credentialsTeachers.teacher_id = self.current_user.teacher.id
          @credentialsTeachers.credential_id = @credential.id
          @credentialsTeachers.save
        elsif self.current_user.school != nil

        end
        format.html { redirect_to '/card/'+self.current_user.teacher.url }
      else
        format.html { redirect_to  '/card/'+self.current_user.teacher.url, :notice => @credential.errors.full_messages.to_sentence }
      end
    end
  end

  def addExperience
    @teacher=Teacher.find(self.current_user.teacher.id)
    @experience = Experience.new(params[:experience])
    @experience.startMonth = params[:date][:startMonth]
    @experience.startYear = params[:date][:startYear]
    @experience.endMonth = params[:date][:endMonth]
    @experience.endYear = params[:date][:endYear]
    
    experience = @teacher.experiences.build(:company => @experience.company, :position => @experience.position, :description => @experience.description, :startMonth => @experience.startMonth, :startYear => @experience.startYear, :endMonth => @experience.endMonth, :endYear => @experience.endYear)
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to '/card/'+@teacher.url }
      else
        format.html { redirect_to '/card/'+@teacher.url, :notice => experience.errors.full_messages.to_sentence }
      end 
    end
  end

  def cardheadline
    @teacher=Teacher.find(self.current_user.teacher.id)
    @teacher.update_attribute(:headline, params[:biography])
    respond_to do |format|
      format.html { redirect_to '/card/'+@teacher.url}
    end
  end

  def addSkills
    @teacher=Teacher.find(self.current_user.teacher.id)
    skill= Skill.find(params[:skill_id])
    SkillClaim.create(:skill_id => skill.id, :skill_group_id => skill.skill_group_id, :user_id => @teacher.user.id)
  end

  def removeSkills
    @teacher=Teacher.find(self.current_user.teacher.id)
    SkillClaim.find(:first, :conditions => ['user_id = ? and skill_id = ?', @teacher.user.id, params[:skill_id]]).destroy
  end

  def change_location
    @teacher=Teacher.find(:first, :conditions => ["user_id = ?", self.current_user.id])
    @teacher.location=params[:location]
    @teacher.save
    redirect_to :back
  end
end
