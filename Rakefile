require "bundler/gem_tasks"
require "rspec/core/rake_task"
task :default => :spec

gem 'rails'
gem 'rest-client'

desc "Run the specs."
RSpec::Core::RakeTask.new do |task|
  task.pattern = "spec/**/*_spec.rb"
  task.verbose = false
end
