class WhiteboardsController < ApplicationController
	layout false

	def show
		page = params[:page].nil? ? 0 : params[:page].to_i - 1
		w = Whiteboard.getActivity.limit(5).offset((page * 5 / page rescue 0)).all
		return render :json => w unless params[:raw].nil?

		divs = Array.new
		w.each do |post|
			@post = post
			divs << render_to_string
		end

		render :json => divs
	end

end