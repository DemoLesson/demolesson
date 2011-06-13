class Notifications < ActionMailer::Base
  def forgot_password(to, login, pass, sent_at = Time.now)
    @subject    = "Your password is ..."
    @body['login']=login
    @body['pass']=pass
    @recipients = to
    @from       = 'demolesson@demolesson.com'
    @sent_on    = sent_at
    @headers    = {}
  end

  def verification(email, name, verification_code, sent_at = Time.now)
    @subject    = "Please validate your demolesson.com registration"
    @body['email']=email
    @body['name']=name
    @body['verification_code']=verification_code
    @recipients = email
    @from       = 'demolesson@demolesson.com'
    @sent_on    = sent_at
    @headers    = {}
  end
end

