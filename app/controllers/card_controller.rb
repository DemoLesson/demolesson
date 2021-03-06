class CardController < ApplicationController
  def get
    @teacher = Teacher.find_by_url(params[:url])
    @video = Video.find(:first, :conditions => ['teacher_id = ? AND is_snippet=?', @teacher.id, false], :order => 'created_at DESC')
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
    
    @uploader = Video.new.video
    @uploader.success_action_redirect = new_video_url

    if @teacher.nil?
      redirect_to "/"
    end
  end

  #for some reason not responding back
  #def addEducation
  #  respond_to do |format|
  #    format.html #get.html.erb
  #    format.json { render :json => { :status => 'success' }}
  #  end
  #end
  #
  def cardavatar
    @user=self.current_user
    respond_to do |format|
      if @user.update_attribute(:avatar, params[:user][:avatar])
        format.html { redirect_to('/card/'+self.current_user.teacher.url) }
      end
    end
  end

  def addEducation
    @teacher = Teacher.find(self.current_user.teacher.id)
    @teacher.educations.build(params[:education])
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to '/card/'+@teacher.url }
      else
        format.html { redirect_to '/card/'+@teacher.url }
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
        format.html { redirect_to  '/card/'+self.current_user.teacher.url }
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
    
    @teacher.experiences.build(:company => @experience.company, :position => @experience.position, :description => @experience.description, :startMonth => @experience.startMonth, :startYear => @experience.startYear, :endMonth => @experience.endMonth, :endYear => @experience.endYear)
    
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to '/card/'+@teacher.url }
      else
        format.html { redirect_to '/card/'+@teacher.url }
      end 
    end
  end

  def cardheadline
    @teacher=Teacher.find(self.current_user.teacher.id)
    @teacher.update_attribute(:headline, params[:bio])
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

  def invalid
    redirect_to "/"
  end
end
