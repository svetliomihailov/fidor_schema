#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new
task :default => :spec


require 'validator'


task :validate_dash do
  Validator.run :dash
end

task :validate_underscore do
  Validator.run :underscore
end

task :validate_jschema do
  Validator.run :jschema
end

task :validate_schema => [:validate_dash, :validate_underscore, :validate_jschema] do

end
