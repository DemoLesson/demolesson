class School < ActiveRecord::Base
  acts_as_mappable
  acts_as_gmappable :msg => "You don't have a location set yet, or it is invalid."
  
  belongs_to :user, :foreign_key => :owned_by
  attr_protected :owned_by

  def gmaps4rails_address
    "#{self.map_address}, #{self.map_city}, #{self.map_state}, #{self.map_zip}" 
  end
  
  def jobs
    @jobs = Job.find(:all, :conditions => ['school_id = ?', self.id])
    return @jobs
  end
end
