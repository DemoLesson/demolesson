desc "Add and change skills to what it had been on the production site"
task :change_skills1 => :environment do

  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Teacher Leadership" ])) != nil)
    skill_group.update_attribute(:name, "Teacher Professsional Development" )
  end

  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Career Development" ])) != nil)
    skill_group.update_attribute(:name, "Career Enhancement" )
  end

  if ((skill_group1 = SkillGroup.find(:first, :conditions => ["name = ?", "Assesment" ])) != nil)
    if ((skill_group2 = SkillGroup.find(:first, :conditions => ["name = ?", "Culture Building" ])) != nil)
      skill_group1.update_attribute(:name, "Culture Building")
      skill_group2.update_attribute(:name, "Assessment")
    end
  end
end

desc "Add and change skills 09/11/2012"
task :change_skills2 => :environment do
  #Erase Skills Tag Section
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Career Enhancement" ])) != nil)
    skill_group.destroy
  end

  #Teacher Professional Development
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Teacher Professional Development" ])) != nil)
    skill_group.update_attribute(:name, "Teacher Leadership")
    skill_group.skills.each do |skill|
      skill.destroy
    end
    Skill.create(:name => "Lead or Facilitate PD", :skill_group_id => skill_group.id)
    Skill.create(:name => "Lead/Master Teacher", :skill_group_id => skill_group.id)
    Skill.create(:name => "Coach/Mentor to Teachers", :skill_group_id => skill_group.id)
  end

  #Technology
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Technology" ])) != nil)
    #1. Add Texas Instruments
    Skill.create(:name => "Texas Instruments", :skill_group_id => skill_group.id)

    #2. Change "1:1 Laptop Computer Learning" to "1:1 Laptop/Computer"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "1:1 Laptop/Computer Learning"])) != nil)
      skill.update_attribute(:name, "1:1 Laptop/Computer")
    end

    #3. Change "1.1 Laptop Computer Learning" to "1:1 Laptop/Computer"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "BYOD (Bring Your Own Device)"])) != nil)
      skill.update_attribute(:name, "BYOD")
    end

    #4. Change "Learning with Mobile Devices to "Mobile Devices"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "learning with Mobile Devices"])) != nil)
      skill.update_attribute(:name, "Mobile Devices")
    end

    #5. Remove "Technology Integration"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Technology Integration"])) != nil)
      skill.destroy
    end
  end

  #Pedagogy themes
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Pedagogy Themes" ])) != nil)
    #1. Add "Flipped Classroom"
    Skill.create(:name => "Flipped Classroom", :skill_group_id => skill_group.id)

    #2. Add "Problem-based Learning"
    Skill.create(:name => "Problem-based Learning", :skill_group_id => skill_group.id)

    #3. Change "Project, Problem, & Challenge Based Learning" to "Project Based Learning"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Project, Problem, & Challenge-based Learning"])) != nil)
      skill.update_attribute(:name, "Project Based Learning")
    end

    #4. Change "Problem Solving & Critical Thinking" to "Critical Thinking"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Problem Solving & Critical Thinking"])) != nil)
      skill.update_attribute(:name, "Critical Thinking")
    end

    #5. Change "Social Justice/Critical Pedagogy" to "social Justice"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Social Justice/Critical Pedagogy"])) != nil)
      skill.update_attribute(:name, "Social Justice")
    end

    #6. Change "21st Century Teaching/Learning" to "21st Century Skills"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "21st Century Teaching/Learning"])) != nil)
      skill.update_attribute(:name, "21st Century Skills")
    end
  end

  #Specializaed Training
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Specialized Training" ])) != nil)
    Skill.create(:name => "National Board Certified", :skill_group_id => skill_group.id)
  end

  #Lesson Plans
  if ((skill_group1 = SkillGroup.find(:first, :conditions => ["name = ?", "Lesson Plans" ])) != nil)
    if ((skill_group2 = SkillGroup.find(:first, :conditions => ["name = ?", "Lesson Materials" ])) != nil)
      skill_group2.destroy
    end
    skill_group1.update_attribute(:name, "Lesson Plans & Materials")
    skill_group1.skills.each do |skill|
      skill.destroy
    end
    Skill.create(:name => "Common Core Standards", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Pacing Plans", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Unit Plans", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Lesson Plans", :skill_group_id => skill_group1.id)
    Skill.create(:name => "PowerPoint/Keynote", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Materials (e.g. worksheets)", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Projects", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Activities and Games", :skill_group_id => skill_group1.id)
    Skill.create(:name => "Groupwork", :skill_group_id => skill_group1.id)
  end

  #Assessment
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Assessment" ])) != nil)
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Standards-Aligned Assessments"])) != nil)
      skill.update_attribute(:name, "Standards-Aligned")
    end
  end

  #Culture Building
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Assessment" ])) != nil)
    #1. Change "Behavior/Classroom Management" to "Behavior Management"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Behavior/Classroom Management"])) != nil)
      skill.update_attribute(:name, "Behavior Management")
    end

    #2. Change "Summer Projects & Activities" to "Summer Projects"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Summer Projects & Activities"])) != nil)
      skill.update_attribute(:name, "Summer Projects")
    end

    #3. Change "Field Trips  Celebrations" to "Field Trips & Events"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Field Trips & Celebrations"])) != nil)
      skill.update_attribute(:name, "Field Trips & Events")
    end
  end

  #Life Skills
  if ((skill_group = SkillGroup.find(:first, :conditions => ["name = ?", "Life Skills"])) != nil)
    #1. Add "Interpersonal & Public Speaking
    Skill.create(:name => "Interpersonal & Public Speaking", :skill_group_id => skill_group.id)

    #2. Add "Social Skills & Character" to "Character Building"
    if((skill = Skill.find(:first, :conditions => ["name = ?", "Social Skills & Character"])) != nil)
      skill.update_attribute(:name, "Character Building")
    end
  end
end
