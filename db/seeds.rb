# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

subjects = Subject.create([{ :name => 'Preschool' }, { :name => 'Early Childhood' }, { :name => 'Elementary' }, { :name => 'Middle Grades' }, { :name => 'Middle School' }, { :name => 'High School' }, { :name => 'All Subjects' }, { :name => 'Accounting' }, { :name => 'Art' }, { :name => 'Arts: Dance' }, { :name => 'Arts: Drama' }, { :name => 'Bilingual Education' }, { :name => 'Business Education' }, { :name => 'Computer Science' }, { :name => 'Consumer & Home Economics' }, { :name => 'Driver Education' }, { :name => 'Economics' }, { :name => 'English & Language Arts' }, { :name => 'English Language Learners / ESL' }, { :name => 'Environmental Education' }, { :name => 'Health' }, { :name => 'JROTC Instructor' }, { :name => 'Keyboarding' }, { :name => 'Language: American Sign' }, { :name => 'Language: Arabic' }, { :name => 'Language: Chinese' }, { :name => 'Language: French' }, { :name => 'Language: German' }, { :name => 'Language: Greek' }, { :name => 'Language: Hebrew' }, { :name => 'Language: Italian' }, { :name => 'Language: Japanese' }, { :name => 'Language: Korean' }, { :name => 'Language: Latin' }, { :name => 'Language: Polish' }, { :name => 'Language: Portuguese' }, { :name => 'Language: Russian' }, { :name => 'Language: Spanish' }, { :name => 'Marketing Education' }, { :name => 'Math: Algebra' }, { :name => 'Math: Calculus' }, { :name => 'Math: General' }, { :name => 'Math: Geometry' }, { :name => 'Math: Trigonometry' }, { :name => 'Montessori' }, { :name => 'Music Education' }, { :name => 'Music: Chorus' }, { :name => 'Music: Instrumental' }, { :name => 'Physical Education' }, { :name => 'Political Science' }, { :name => 'Public Speaking' }, { :name => 'Reading/Literacy' }, { :name => 'Religion' }, { :name => 'Science: Astronomy' }, { :name => 'Science: Biology' }, { :name => 'Science: Chemistry' }, { :name => 'Science: Earth & Space' }, { :name => 'Science: General' }, { :name => 'Science: Geology' }, { :name => 'Science: Physics' }, { :name => 'Social Studies: Current Issues' }, { :name => 'Social Studies: General' }, { :name => 'Social Studies: Geography' }, { :name => 'Social Studies: Government' }, { :name => 'Social Studies: Military' }, { :name => 'Social Studies: US History' }, { :name => 'Social Studies: World History' }, { :name => 'Special Education' }, { :name => 'Technology Education' }, { :name => 'Video Production' }, { :name => 'Assistant Principal/Dean/Head' }, { :name => 'Assistant/Deputy Superintendent' }, { :name => 'Athletic/Activities Director' }, { :name => 'Business/Finance' }, { :name => 'Curriculum' }, { :name => 'Development / Marketing' }, { :name => 'Director/Coordinator/Manager' }, { :name => 'Facilities' }, { :name => 'Food Services' }, { :name => 'Human Resources' }, { :name => 'Principal/Dean/Head of School' }, { :name => 'Public Affairs / Relations' }, { :name => 'Pupil Personnel' }, { :name => 'Safety/Security' }, { :name => 'Special Education Director' }, { :name => 'Superintendent' }, { :name => 'Technology' }, { :name => 'Transportation' }, { :name => 'Vocational/Career Education' }, { :name => 'After School Programs' }, { :name => 'Athletic/Activities Director' }, { :name => 'Coaching' }, { :name => 'Theater Production' }, { :name => 'Trainer' }, { :name => 'Adaptive Physical Education' }, { :name => 'Autism' }, { :name => 'Behavior Specialist / EBD' }, { :name => 'Consulting Teacher' }, { :name => 'Early Essential Education' }, { :name => 'Emotionally Disabled' }, { :name => 'General Special Education' }, { :name => 'Gifted & Talented' }, { :name => 'Hard of Hearing' }, { :name => 'Learning Disabled' }, { :name => 'Life Skills' }, { :name => 'Mentally Disabled' }, { :name => 'Mild/Moderate Disabilities' }, { :name => 'Multiple Disabilities' }, { :name => 'Occupational Therapist' }, { :name => 'OT Assistant' }, { :name => 'Physical Therapist' }, { :name => 'PT Assistant' }, { :name => 'Severe/Profound Disabilities' }, { :name => 'Special Education Assistant' }, { :name => 'Speech/Language Assistant' }, { :name => 'Speech/Language Pathologist' }, { :name => 'Visually Impaired' }])

skill_groups = SkillGroup.create([{:name => 'Technology', :badge_url => '/assets/badges/technology.png', :placeholder => "This teacher is wise in the ways of technology in the classroom.  Did you know that 51% of eight graders haven't used a computer for school? Change it." }, 
                                 {:name => 'Lesson Plans', :badge_url => '/assets/badges/lesson-plans.png', :placeholder => "This teacher's lesson planning powers are especially skilled.  Did you know that on average Chicago teachers work 53 hour weeks?" }, 
                                 {:name => 'Lesson Materials', :badge_url => '/assets/badges/lesson-materials.png', :placeholder => "Developing materials and tools for class is a specialty for this teacher. Did you know that 48% of classrooms have a LCD or DLP projector in them?" }, 
                                 {:name => 'Assesment', :badge_url => '/assets/badges/assessment.png', :placeholder => "This teacher makes assessing students an art.  Did you know that using digital games can increase test scores? (Like, 20%!)" }, 
                                 {:name => 'Culture Building', :badge_url => '/assets/badges/culture-building.png', :placeholder => "This spirited teacher has great skills building a valuable learning environment.  Did you know that after-school programs increase attendance, behavior and course work?" }, 
                                 {:name => 'Life Skills', :badge_url => '/assets/badges/life-skills.png', :placeholder => "This teacher is an amazing guide for life and lights the way for students' futures.  Did you know that unemployment halved for college graduates?" }, 
                                 {:name => 'Pedagogy Themes', :badge_url => '/assets/badges/pedagogy-themes.png', :placeholder => "Innovative teaching strategies are a forte for this teacher.  Did you know that 3/4 of teachers think they need more technology in class?"}, 
                                 {:name => 'Career Development', :badge_url => '/assets/badges/career-development.png', :placeholder => "This teacher is ace at prepping a student to begin their career.  Did you know that college graduates, on average, earn 38% more?" }, 
                                 {:name => 'Teacher Leadership', :badge_url => '/assets/badges/teacher-leadership.png', :placeholder => "Leading the charge is a great strength for this teacher.  Did you know that Gene Simmons use to teach 6th grade?" }, 
                                 {:name => 'Specialized Training', :badge_url => '/assets/badges/specialized-training.png', :placeholder => "This teacher has been upgraded thanks to great teacher organizations.  Did you know that Teach for America has nearly 28,000 Corps Members?" }])

skills = Skill.create([{:name => 'Interactive Whiteboards', :skill_group_id => skill_groups.first.id},
  {:name => 'iPad', :skill_group_id => skill_groups.first.id},
  {:name => 'Tablet', :skill_group_id => skill_groups.first.id},
  {:name => 'Education Apps', :skill_group_id => skill_groups.first.id},
  {:name => '1:1 Laptop/Computer Learning', :skill_group_id => skill_groups.first.id},
  {:name => 'Flipped Classroom', :skill_group_id => skill_groups.first.id},
  {:name => 'BYOD (Bring Your Own Device)', :skill_group_id => skill_groups.first.id},
  {:name => 'Digital Portfolios', :skill_group_id => skill_groups.first.id},
  {:name => 'Virtual Classroom', :skill_group_id => skill_groups.first.id},
  {:name => 'Social Media/Web 2.0', :skill_group_id => skill_groups.first.id},
  {:name => 'learning with Mobile Devices', :skill_group_id => skill_groups.first.id},
  {:name => 'Multimedia/Video', :skill_group_id => skill_groups.first.id},
  {:name => 'Podcasting', :skill_group_id => skill_groups.first.id},
  {:name => 'Web/Internet', :skill_group_id => skill_groups.first.id},
  {:name => 'Technology Standards', :skill_group_id => skill_groups.first.id},
  {:name => 'Technology Integration', :skill_group_id => skill_groups.first.id},
  {:name => 'Vision & Goals', :skill_group_id => skill_groups[1].id},
  {:name => 'Pacing Plans', :skill_group_id => skill_groups[1].id},
  {:name => 'Standards', :skill_group_id => skill_groups[1].id},
  {:name => 'Units', :skill_group_id => skill_groups[1].id},
  {:name => 'Lessons', :skill_group_id => skill_groups[1].id},
  {:name => 'Presentations', :skill_group_id => skill_groups[2].id},
  {:name => 'Student Materials (e.g. handouts, homework)', :skill_group_id => skill_groups[2].id},
  {:name => 'Projects, Labs, Activities', :skill_group_id => skill_groups[2].id},
  {:name => 'Groupwork', :skill_group_id => skill_groups[2].id},
  {:name => 'Classroom Environment', :skill_group_id => skill_groups[3].id},
  {:name => 'Behavior/Classroom Management', :skill_group_id => skill_groups[3].id},
  {:name => 'Investment', :skill_group_id => skill_groups[3].id},
  {:name => 'Families & Communities', :skill_group_id => skill_groups[3].id},
  {:name => 'Summer Projects & Activities', :skill_group_id => skill_groups[3].id},
  {:name => 'Back-to-School', :skill_group_id => skill_groups[3].id},
  {:name => 'Field Trips & Celebrations', :skill_group_id => skill_groups[3].id},
  {:name => 'Fundraising', :skill_group_id => skill_groups[3].id},
  {:name => 'Review & Test Prep', :skill_group_id => skill_groups[4].id},
  {:name => 'Research Skills', :skill_group_id => skill_groups[4].id},
  {:name => 'Study/Test Skills', :skill_group_id => skill_groups[4].id},
  {:name => 'Rubrics', :skill_group_id => skill_groups[4].id},
  {:name => 'Standards-Aligned Assessments', :skill_group_id => skill_groups[4].id},
  {:name => 'Common Core', :skill_group_id => skill_groups[4].id},
  {:name => 'Social Skills & Character', :skill_group_id => skill_groups[5].id},
  {:name => 'College & Career', :skill_group_id => skill_groups[5].id},
  {:name => 'Entrepreneurship', :skill_group_id => skill_groups[5].id},
  {:name => 'Project, Problem, & Challenge-based Learning', :skill_group_id => skill_groups[6].id},
  {:name => 'Problem Solving & Critical Thinking', :skill_group_id => skill_groups[6].id},
  {:name => 'Social Justice/Critical Pedagogy', :skill_group_id => skill_groups[6].id},
  {:name => '21st Century Teaching/Learning', :skill_group_id => skill_groups[6].id},
  {:name => 'Digital Citizenship', :skill_group_id => skill_groups[6].id},
  {:name => 'International/Global', :skill_group_id => skill_groups[6].id},
  {:name => 'Resume Support', :skill_group_id => skill_groups[7].id},
  {:name => 'Interview Support', :skill_group_id => skill_groups[7].id},
  {:name => 'Demo Lesson', :skill_group_id => skill_groups[7].id},
  {:name => 'Teacher Observation', :skill_group_id => skill_groups[8].id},
  {:name => 'Teacher Coaching/Mentorship', :skill_group_id => skill_groups[8].id},
  {:name => 'Professional Development', :skill_group_id => skill_groups[8].id},
  {:name => 'Teach for America', :skill_group_id => skill_groups[9].id},
  {:name => 'The New Teacher Project', :skill_group_id => skill_groups[9].id},
  {:name => 'TeachPlus', :skill_group_id => skill_groups[9].id},
  {:name => 'The College Ready Promise', :skill_group_id => skill_groups[9].id}])

  
                       
topics = Eventtopic.create([{ :name => '1:1 Classrooms and Schools' },{ :name => 'Behavior management' },{ :name => 'Bring Your Own Device (BYOD)' },{ :name => 'College & career preparation' },{ :name => 'Edtech' },{ :name => 'Entrepreneurship' },{ :name => 'Family/Community' },{ :name => 'Flipped Classroom' },{ :name => 'Home schooling' },{ :name => 'Humanities' },{ :name => 'Investment/culture building' },{ :name => 'International education' },{ :name => 'Job support' },{ :name => 'Lesson and assessment planning' },{ :name => 'Life/social skills' },{ :name => 'Networking' },{ :name => 'Political Advocacy' },{ :name => 'Professional development' },{ :name => 'Project-based learning' },{ :name => 'School Leadership' },{ :name => 'Social Justice/critical pedagogy' },{ :name => 'Standards-based teaching and grading' },{ :name => 'STEM' },{ :name => 'Virtual learning' }])
format = Eventformat.create([{ :name => "Conference", :virtual => 0 },{ :name => "Course/Class", :virtual => 0 },{ :name => "Exhibit/Expo", :virtual => 0 },{ :name => "Forum/Panel Discussion", :virtual => 0 },{ :name => "Meet-up", :virtual => 0 },{ :name => "Professional Learning Network (PLN)", :virtual => 0 },{ :name => "Presentation", :virtual => 0 },{ :name => "Online Course/Class", :virtual => 1 },{ :name => "Phone conference", :virtual => 1 },{ :name => "Podcast", :virtual => 1 },{ :name => "Twitter", :virtual => 1 },{ :name => "Television", :virtual => 1 },{ :name => "Webinar", :virtual => 1 }])
