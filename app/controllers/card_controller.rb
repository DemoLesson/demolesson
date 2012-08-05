class CardController < ApplicationController
  def get
    if params[:url].nil?
      redirect_to "/"
    else
      render :json => params[:url]
    end
  end

  def invalid
    redirect_to "/"
  end
end
