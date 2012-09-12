class WelcomeWizardController < ApplicationController
	layout 'wizard'

	def index
		@buri = '/welcome_wizard'

		# Route to other steps/methods
		return self.send(params[:x]) unless params[:x].nil?

		# Make sure the user is not logged in
		unless self.current_user.nil?
			return redirect_to :root
		end
	end

	def step1

		# Make sure the user is not logged in
		unless self.current_user.nil?
			flash[:notice] = "You cannot go to step 1 of the welcome wizard after you have joined the site."
			return redirect_to :root
		end
		
		# Detect post variables
		if request.post?

			# Generate a new password
			params[:user][:password] = User.random_string(10)
			params[:user][:confirm_password] = params[:user][:password]

			# Create a new user
			@user = User.new(params[:user])
			
			# Attempt to save the user
			if @user.save

				# If the user saved then create the teacher record on the user
				@user.create_teacher

				# Go ahead and email the user with their login details
				UserMailer.teacher_welcome_email_temppassword(@user.id, params[:user][:password]).deliver

				# Authenticate the user
				session[:user] = User.authenticate(@user.email, @user.password)

				# Wizard Key
				wKey = "welcome_wizard_step1" + (session[:_ak].nil? ? '' : '_[' + session[:_ak] + ']')

				# And create an analytic
				self.log_analytic(:user_signup, "New user signed up.", @user)
				self.log_analytic(wKey, "User completed step 1 of the welcome wizard.", @user)

				# Notice and redirect
				flash[:notice] = "Signup successful"
				return redirect_to @buri + '?x=step2'
			else

				# If the user save failed then notice and redirect
				flash[:notice] = @user.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step1'
			end
		end

		render :step1
	end

	def step2

		# Make sure the user has a teacher if not error
		if self.current_user.nil? || self.current_user.teacher.nil?
			flash[:notice] = "You must be logged in to continue in the wizard and if you are then you need a teacher record. If you believe you received this message in error please contact support."
			return redirect_to :root
		end

		# Detect post variables
		if request.post?

			# Load the teach and update
			@teacher = self.current_user.teacher
			@teacher.update_attributes(params[:teacher])

			# Clean empty results from the hash
			params.clean!

			unless params[:edu].nil? || params[:edu].empty?

				# Get full date objects for start and end dates
				start_date = params[:date][:edu_start_month] + '/' + params[:date][:edu_start_year]
				start_date = Time.strptime(start_date, "%m/%Y")
				end_date = params[:date][:edu_end_month] + '/' + params[:date][:edu_end_year]
				end_date = Time.strptime(end_date, "%m/%Y")

				# Go ahead and make that just years cause the db structure is lame
				params[:edu][:start_year] = start_date.strftime("%Y")
				params[:edu][:year] = end_date.strftime("%Y")

				# Build the education data
				@teacher.educations.build(params[:edu])
			end

			unless params[:experience].nil? || params[:experience].empty?

				# Get full date objects for start and end dates
				start_date = params[:date][:exp_start_month] + '/' + params[:date][:exp_start_year]
				start_date = Time.strptime(start_date, "%m/%Y")
				end_date = params[:date][:exp_end_month] + '/' + params[:date][:exp_end_year]
				end_date = Time.strptime(end_date, "%m/%Y")

				# Go ahead and make that months and years again because the db structure is lame
				params[:experience][:startMonth] = start_date.strftime("%m")
				params[:experience][:startYear] = start_date.strftime("%Y")
				params[:experience][:endMonth] = end_date.strftime("%m")
				params[:experience][:endYear] = end_date.strftime("%Y")

				# Build the experience data
				@teacher.experiences.build(params[:experience])
			end
			
			# Attempt to save the user
			if @teacher.save

				# Wizard Key
				wKey = "welcome_wizard_step2" + (session[:_ak].nil? ? '' : '_[' + session[:_ak] + ']')

				# And create an analytic
				self.log_analytic(wKey, "User completed step 2 of the welcome wizard.", self.current_user)

				# Notice and redirect
				flash[:notice] = "Step 2 Completed"
				return redirect_to @buri + '?x=step3'
			else

				# If the user save failed then notice and redirect
				dump flash[:notice] = @teacher.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step2'
			end
		end

		render :step2
	end

	def step3

		# Make sure the user has a teacher if not error
		if self.current_user.nil? || self.current_user.teacher.nil?
			flash[:notice] = "You must be logged in to continue in the wizard and if you are then you need a teacher record. If you believe you received this message in error please contact support."
			return redirect_to :root
		end

		# Detect post variables
		if request.post?

			# Load the teach and update
			@teacher = self.current_user.teacher
			@teacher.user.skills.delete_all
			
			# Install the skills
			skills = Skill.where(:id => params[:skills].split(','))
			skills.each do |skill|
				SkillClaim.create(:user_id => @teacher.user.id, :skill_id => skill.id, :skill_group_id => skill.skill_group_id)
			end

			#dump skills
			@teacher.skills = skills
			
			# Attempt to save the user
			if @teacher.save

				# Wizard Key
				wKey = "welcome_wizard_step3" + (session[:_ak].nil? ? '' : '_[' + session[:_ak] + ']')

				# And create an analytic
				self.log_analytic(wKey, "User completed step 3 of the welcome wizard.", self.current_user)

				# Notice and redirect
				session[:wizard] = true
				flash[:notice] = "Step 3 Completed"
				return redirect_to @buri + '?x=step4'
			else

				# If the user save failed then notice and redirect
				flash[:notice] = @teacher.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step3'
			end
		end

		# Get a list of existing skills
		@existing_skills = teacher_path(self.current_user.teacher) + '/skills'

		render :step3
	end

	def step4

		# Make sure the user has a teacher if not error
		if self.current_user.nil? || self.current_user.teacher.nil?
			flash[:notice] = "You must be logged in to continue in the wizard and if you are then you need a teacher record. If you believe you received this message in error please contact support."
			return redirect_to :root
		end

		@user = self.current_user

		render :step4
	end

	def step5

		# Make sure the user has a teacher if not error
		if self.current_user.nil? || self.current_user.teacher.nil?
			flash[:notice] = "You must be logged in to continue in the wizard and if you are then you need a teacher record. If you believe you received this message in error please contact support."
			return redirect_to :root
		end

		@user = self.current_user

		render :step5
	end	

	# # # # # # # # # # # # # # # # # # # # # #
	 # # # # # # # # # # # # # # # # # # # # #
	# # # # # # # # # # # # # # # # # # # # # #

	def update_aboutme
		if params.has_key?("aboutme")
			@teacher = self.current_user.teacher
			if @teacher.update_attribute(:headline, params["aboutme"])
				data = {"type" => 'success', "message" => 'Saved successfuly'}
			else
				data = {"type" => 'error', "message" => 'There was a problem saving'}
			end
		else
			data = {"type" => 'error', "message" => 'There was not data passed'}
		end

		render :json => data
	end

	# Catch rails args
	def create(*args)
		self.send('index', *args)
	end

end