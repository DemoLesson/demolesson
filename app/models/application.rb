class Application < ActiveRecord::Base
  
  def belongs_to_me
  
  end

  def teacher 
    @teacher = Teacher.find(self.teacher_id)
    return @teacher
  end  
end
