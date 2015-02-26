#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new
task :default => :spec


require 'validate/validate'


task :validate_dash do
  Fidor::SchemaValidation.main :dash
end

task :validate_underscore do
  Fidor::SchemaValidation.main :underscore
end

task :validate_jschema do
  Fidor::SchemaValidation.main :jschema
end

task :validate_schema => [:validate_dash, :validate_underscore, :validate_jschema] do
  
end
