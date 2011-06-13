require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :password, :within => 5..40
  validates_presence_of :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  

  attr_protected :id, :salt, :is_admin, :verified

  attr_accessor :password, :password_confirmation
  
  after_create :send_verification_email

  def teacher
    return(Teacher.find(:first, :conditions => {:user_id => id}))
  end

  def school
    return(School.find(:first, :conditions => {:owned_by => id}))
  end

  def self.authenticate(email, pass)
    u=find(:first, :conditions=>["email = ?", email])
#	logger.info("found user #{u.inspect}")
    return nil if u.nil?
#	logger.info("seeing if #{User.encrypt(pass, u.salt)}==#{u.hashed_password}")
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end
  
  def send_verification_email
    self.verification_code = User.random_string(10)
    self.save
    Notifications.deliver_verification(self.email, self.name, self.verification_code)
  end
  
  def self.verify!(email, verification_code)
    u=find(:first, :conditions=>["email = ?", email])
    if (u.present? && u.verification_code == verification_code)
      u.is_verified = true
      u.save
    else
      raise "verification code does not match email or unregistered email"
    end
  end
    
  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.name, new_pass)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
