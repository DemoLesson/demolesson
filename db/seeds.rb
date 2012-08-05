# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

subjects = Subject.create([{ :name => 'Preschool' }, { :name => 'Early Childhood' }, { :name => 'Elementary' }, { :name => 'Middle Grades' }, { :name => 'Middle School' }, { :name => 'High School' }, { :name => 'All Subjects' }, { :name => 'Accounting' }, { :name => 'Art' }, { :name => 'Arts: Dance' }, { :name => 'Arts: Drama' }, { :name => 'Bilingual Education' }, { :name => 'Business Education' }, { :name => 'Computer Science' }, { :name => 'Consumer & Home Economics' }, { :name => 'Driver Education' }, { :name => 'Economics' }, { :name => 'English & Language Arts' }, { :name => 'English Language Learners / ESL' }, { :name => 'Environmental Education' }, { :name => 'Health' }, { :name => 'JROTC Instructor' }, { :name => 'Keyboarding' }, { :name => 'Language: American Sign' }, { :name => 'Language: Arabic' }, { :name => 'Language: Chinese' }, { :name => 'Language: French' }, { :name => 'Language: German' }, { :name => 'Language: Greek' }, { :name => 'Language: Hebrew' }, { :name => 'Language: Italian' }, { :name => 'Language: Japanese' }, { :name => 'Language: Korean' }, { :name => 'Language: Latin' }, { :name => 'Language: Polish' }, { :name => 'Language: Portuguese' }, { :name => 'Language: Russian' }, { :name => 'Language: Spanish' }, { :name => 'Marketing Education' }, { :name => 'Math: Algebra' }, { :name => 'Math: Calculus' }, { :name => 'Math: General' }, { :name => 'Math: Geometry' }, { :name => 'Math: Trigonometry' }, { :name => 'Montessori' }, { :name => 'Music Education' }, { :name => 'Music: Chorus' }, { :name => 'Music: Instrumental' }, { :name => 'Physical Education' }, { :name => 'Political Science' }, { :name => 'Public Speaking' }, { :name => 'Reading/Literacy' }, { :name => 'Religion' }, { :name => 'Science: Astronomy' }, { :name => 'Science: Biology' }, { :name => 'Science: Chemistry' }, { :name => 'Science: Earth & Space' }, { :name => 'Science: General' }, { :name => 'Science: Geology' }, { :name => 'Science: Physics' }, { :name => 'Social Studies: Current Issues' }, { :name => 'Social Studies: General' }, { :name => 'Social Studies: Geography' }, { :name => 'Social Studies: Government' }, { :name => 'Social Studies: Military' }, { :name => 'Social Studies: US History' }, { :name => 'Social Studies: World History' }, { :name => 'Special Education' }, { :name => 'Technology Education' }, { :name => 'Video Production' }, { :name => 'Assistant Principal/Dean/Head' }, { :name => 'Assistant/Deputy Superintendent' }, { :name => 'Athletic/Activities Director' }, { :name => 'Business/Finance' }, { :name => 'Curriculum' }, { :name => 'Development / Marketing' }, { :name => 'Director/Coordinator/Manager' }, { :name => 'Facilities' }, { :name => 'Food Services' }, { :name => 'Human Resources' }, { :name => 'Principal/Dean/Head of School' }, { :name => 'Public Affairs / Relations' }, { :name => 'Pupil Personnel' }, { :name => 'Safety/Security' }, { :name => 'Special Education Director' }, { :name => 'Superintendent' }, { :name => 'Technology' }, { :name => 'Transportation' }, { :name => 'Vocational/Career Education' }, { :name => 'After School Programs' }, { :name => 'Athletic/Activities Director' }, { :name => 'Coaching' }, { :name => 'Theater Production' }, { :name => 'Trainer' }, { :name => 'Adaptive Physical Education' }, { :name => 'Autism' }, { :name => 'Behavior Specialist / EBD' }, { :name => 'Consulting Teacher' }, { :name => 'Early Essential Education' }, { :name => 'Emotionally Disabled' }, { :name => 'General Special Education' }, { :name => 'Gifted & Talented' }, { :name => 'Hard of Hearing' }, { :name => 'Learning Disabled' }, { :name => 'Life Skills' }, { :name => 'Mentally Disabled' }, { :name => 'Mild/Moderate Disabilities' }, { :name => 'Multiple Disabilities' }, { :name => 'Occupational Therapist' }, { :name => 'OT Assistant' }, { :name => 'Physical Therapist' }, { :name => 'PT Assistant' }, { :name => 'Severe/Profound Disabilities' }, { :name => 'Special Education Assistant' }, { :name => 'Speech/Language Assistant' }, { :name => 'Speech/Language Pathologist' }, { :name => 'Visually Impaired' }])

skill_groups = SkillGroup.create([{:name => 'Technology', :badge_url => '/assets/badges/technology.png'}, {:name => 'Lesson Plans', :badge_url => '/assets/badges/lesson-plans.png'}, {:name => 'Lesson Materials', :badge_url => '/assets/badges/lesson-materials.png'}, {:name => 'Assesment', :badge_url => '/assets/badges/assessment.png'}, {:name => 'Culture Building', :badge_url => '/assets/badges/culture-building.png'}, {:name => 'Life Skills', :badge_url => '/assets/badges/life-skills.png'}, {:name => 'Pedagogy Themes', :badge_url => '/assets/badges/pedagogy-themes.png'}, {:name => 'Career Development', :badge_url => '/assets/badges/career-development.png'}, {:name => 'Teacher Leadership', :badge_url => '/assets/badges/teacher-leadership.png'}, {:name => 'Specialized Training', :badge_url => '/assets/badges/specialized-training.png'}])

skills = Skill.create
([{:name => 'Interactive Whiteboards', :skill_group_id => skill_groups.first},
  {:name => 'iPad', :skill_group_id => skill_groups.first},
  {:name => 'Tablet', :skill_group_id => skill_groups.first},
  {:name => 'Education Apps', :skill_group_id => skill_groups.first},
  {:name => '1:1 Laptop/Computer Learning', :skill_group_id => skill_groups.first},
  {:name => 'Flipped Classroom', :skill_group_id => skill_groups.first},
  {:name => 'BYOD (Bring Your Own Device)', :skill_group_id => skill_groups.first},
  {:name => 'Digital Portfolios', :skill_group_id => skill_groups.first},
  {:name => 'Virtual Classroom', :skill_group_id => skill_groups.first},
  {:name => 'Social Media/Web 2.0', :skill_group_id => skill_groups.first},
  {:name => 'learning with Mobile Devices', :skill_group_id => skill_groups.first},
  {:name => 'Multimedia/Video', :skill_group_id => skill_groups.first},
  {:name => 'Podcasting', :skill_group_id => skill_groups.first},
  {:name => 'Web/Internet', :skill_group_id => skill_groups.first},
  {:name => 'Technology Standards', :skill_group_id => skill_groups.first},
  {:name => 'Technology Integration', :skill_group_id => skill_groups.first},
  {:name => 'Vision & Goals', :skill_group_id => skill_groups[1]},
  {:name => 'Pacing Plans', :skill_group_id => skill_groups[1]},
  {:name => 'Standards', :skill_group_id => skill_groups[1]},
  {:name => 'Units', :skill_group_id => skill_groups[1]},
  {:name => 'Lessons', :skill_group_id => skill_groups[1]},
  {:name => 'Presentations', :skill_group_id => skill_groups[2]},
  {:name => 'Student Materials (e.g. handouts, homework)', :skill_group_id => skill_groups[2]},
  {:name => 'Projects, Labs, Activities', :skill_group_id => skill_groups[2]},
  {:name => 'Groupwork', :skill_group_id => skill_groups[2]},
  {:name => 'Classroom Environment', :skill_group_id => skill_groups[3]},
  {:name => 'Behavior/Classroom Management', :skill_group_id => skill_groups[3]},
  {:name => 'Investment', :skill_group_id => skill_groups[3]},
  {:name => 'Families & Communities', :skill_group_id => skill_groups[3]},
  {:name => 'Summer Projects & Activities', :skill_group_id => skill_groups[3]},
  {:name => 'Back-to-School', :skill_group_id => skill_groups[3]},
  {:name => 'Field Trips & Celebrations', :skill_group_id => skill_groups[3]},
  {:name => 'Fundraising', :skill_group_id => skill_groups[3]},
  {:name => 'Review & Test Prep', :skill_group_id => skill_groups[4]},
  {:name => 'Research Skills', :skill_group_id => skill_groups[4]},
  {:name => 'Study/Test Skills', :skill_group_id => skill_groups[4]},
  {:name => 'Rubrics', :skill_group_id => skill_groups[4]},
  {:name => 'Standards-Aligned Assessments', :skill_group_id => skill_groups[4]},
  {:name => 'Common Core', :skill_group_id => skill_groups[4]},
  {:name => 'Social Skills & Character', :skill_group_id => skill_groups[5]},
  {:name => 'College & Career', :skill_group_id => skill_groups[5]},
  {:name => 'Entrepreneurship', :skill_group_id => skill_groups[5]},
  {:name => 'Project, Problem, & Challenge-based Learning', :skill_group_id => skill_groups[6]},
  {:name => 'Problem Solving & Critical Thinking', :skill_group_id => skill_groups[6]},
  {:name => 'Social Justice/Critical Pedagogy', :skill_group_id => skill_groups[6]},
  {:name => '21st Century Teaching/Learning', :skill_group_id => skill_groups[6]},
  {:name => 'Digital Citizenship', :skill_group_id => skill_groups[6]},
  {:name => 'International/Global', :skill_group_id => skill_groups[6]},
  {:name => 'Resume Support', :skill_group_id => skill_groups[7]},
  {:name => 'Interview Support', :skill_group_id => skill_groups[7]},
  {:name => 'Demo Lesson', :skill_group_id => skill_groups[7]},
  {:name => 'Teacher Observation', :skill_group_id => skill_groups[8]},
  {:name => 'Teacher Coaching/Mentorship', :skill_group_id => skill_groups[8]},
  {:name => 'Professional Development', :skill_group_id => skill_groups[8]},
  {:name => 'Teach for America', :skill_group_id => skill_groups[9]},
  {:name => 'The New Teacher Project', :skill_group_id => skill_groups[9]},
  {:name => 'TeachPlus', :skill_group_id => skill_groups[9]},
  {:name => 'The College Ready Promise', :skill_group_id => skill_groups[9]},])

  
                       
