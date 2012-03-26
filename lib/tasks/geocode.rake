require 'rubygems'

namespace :geocode do
  desc "Migrate school gps data to jobs"
  task :update => :environment do
    @jobs = Job.all
    @jobs.each do |job|
      job.latitude = job.school.latitude
      job.longitude = job.school.longitude
      job.save
    end
  end
end