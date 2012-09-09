class WhiteboardsController < ApplicationController
	layout false

	def show
		w = Whiteboard.getActivity.paginate(:per_page => 5, :page => params[:page]).all
		return render :json => w unless params[:raw].nil?

		divs = Array.new
		w.each do |post|
			@post = post
			divs << render_to_string
		end

		render :json => divs
	end

	def hide
		w = Whiteboard.find(params[:post])
		w.whiteboard_hidden << self.current_user
    	redirect_to :root
	end

end