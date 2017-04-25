require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :test do

  desc "run tests and generate invoke coveralls"
  task :coveralls do
    ENV['COVERALLS'] = 'true'
    Rake::Task[:coverage].invoke
  end

  desc "run tests and generate code coverage"
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task[:spec].invoke
  end
end
