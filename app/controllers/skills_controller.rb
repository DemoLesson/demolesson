class SkillsController < ApplicationController
  def get
    if params[:q].nil?
      @skills = Skill.all(:limit => 10)
    else
      @skills = Skill.where("name like ?", "%#{params[:q]}%")
    end
  end
end
