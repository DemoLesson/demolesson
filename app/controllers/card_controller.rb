class CardController < ApplicationController
  def get
    @teacher = Teacher.find_by_url(params[:url])

    if @teacher.nil?
      redirect_to "/"
    end
  end

  def invalid
    redirect_to "/"
  end
end
