class SkillsController < ApplicationController
  def get
    if params[:q].nil?
      @skills = Skill.all(:limit => 10)
    else
      @skills = Skill.where("name like ?", "%#{params[:q]}%").limit(10)
    end

    respond_to do |format|
      format.json { render :json => @skills }
    end
  end

  def teacherskills
    @skill = Skill.find(params[:id])
    @teachers = Teacher.joins(:user => :skills).paginate(:page => params[:page], :per_page => 25, :conditions => ['teachers.user_id = skill_claims.user_id and skill_claims.skill_id = ?', params[:id]])
  end
end
