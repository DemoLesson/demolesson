class WelcomeWizardController < ApplicationController

	def index
		@buri = '/welcome_wizard'
		@style = render_to_string :partial => 'style'

		# Route to other steps/methods
		return self.send(params[:x]) unless params[:x].nil?
	end

	def step1
		
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

				# And create an analytic
				self.log_analytic(:user_signup, "New user signed up.", @user)
				self.log_analytic(:welcome_wizard_step1, "User completed step 1 of the welcome wizard.", @user)

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
			
			# Attempt to save the user
			if @teacher.save

				# And create an analytic
				self.log_analytic(:welcome_wizard_step2, "User completed step 2 of the welcome wizard.", @user)

				# Notice and redirect
				flash[:notice] = "Step 2 Completed"
				return redirect_to @buri + '?x=step3'
			else

				# If the user save failed then notice and redirect
				flash[:notice] = @teacher.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step2'
			end
		end

		render :step2
	end

	def step3

		# Detect post variables
		if request.post?

			# Make sure the user has a teacher if not error
			if self.current_user.nil? || self.current_user.teacher.nil?
				flash[:notice] = "You must be logged in to continue in the wizard and if you are then you need a teacher record. If you believe you received this message in error please contact support."
				return redirect_to :root
			end

			# Load the teach and update
			@teacher = self.current_user.teacher
			@teacher.educations.build(params[:edu])
			
			# Attempt to save the user
			if @teacher.save

				# And create an analytic
				self.log_analytic(:welcome_wizard_step3, "User completed step 3 of the welcome wizard.", @user)

				# Notice and redirect
				flash[:notice] = "Step 3 Completed"
				return redirect_to @buri + '?x=step4'
			else

				# If the user save failed then notice and redirect
				flash[:notice] = @teacher.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step3'
			end
		end

		# Get an array of years
		@years = Hash.new
		year = Time.now.strftime('%Y').to_i
		i = year + 10; while i >= (year - 100)
			@years[i] = i == year ? "selected" : false; i -= 1
		end

		render :step3
	end

	def step4

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

				# And create an analytic
				self.log_analytic(:welcome_wizard_step4, "User completed step 4 of the welcome wizard.", @user)

				# Notice and redirect
				flash[:notice] = "Step 4 Completed"
				return redirect_to '/inviteconnections'
			else

				# If the user save failed then notice and redirect
				flash[:notice] = @teacher.errors.full_messages.to_sentence
				return redirect_to @buri + '?x=step4'
			end
		end

		# Get a list of existing skills
		@existing_skills = teacher_path(self.current_user.teacher) + '/skills'

		render :step4
	end

	# # # # # # # # # # # # # # # # # # # # # #
	 # # # # # # # # # # # # # # # # # # # # #
	# # # # # # # # # # # # # # # # # # # # # #

	# Catch rails args
	def create(*args)
		self.send('index', *args)
	end

end