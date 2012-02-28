class AlphasController < ApplicationController
  layout 'standard'
  
  def index    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def beta
    @alpha = Alpha.new
    
    respond_to do |format|
      format.html # beta.html.erb
    end
  end
  
  def teacher
    @alpha = Alpha.new
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def admin
    @alpha = Alpha.new
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def general
    @alpha = Alpha.new
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def create
     @alpha = Alpha.new(params[:alpha])

     respond_to do |format|
       if @alpha.email.size > 0 
         if @alpha.save
           if @alpha.userType != 4
             @passcode = Passcode.find_by_given_out(nil)
             @passcode.given_out = true
             @passcode.sent_to = @alpha.email
             @passcode.save!
             format.html { redirect_to '/signup?passcode='+@passcode.code+'&email='+@alpha.email+'&name='+@alpha.name }
           else
            UserMailer.beta_notification(@alpha.name, @alpha.email, @alpha.userType, @alpha.beta).deliver
            format.html { redirect_to(:root, :notice => 'Thanks! We will be in touch shortly.') }
          end
         else
           format.html { redirect_to(:root, :notice => 'An error occured - please try again.') }
         end
       end
       format.html { redirect_to(:root, :notice => 'Please enter your email.') }
     end
  end
end
