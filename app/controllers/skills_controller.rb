class SkillsController < ApplicationController
  def get
    if params[:q].nil?
      @skills = Skill.all(:limit => 10)
    else
<<<<<<< HEAD
      @skills = Skill.where("name like ?", "%#{params[:q]}%")
=======
      @skills = Skill.where("name like ?", "%#{params[:q]}%").limit(10)
    end

    respond_to do |format|
      format.json { render :json => @skills }
>>>>>>> feature/skill-badges
    end
  end
end
