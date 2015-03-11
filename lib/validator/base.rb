# This functionality is intended to run the schema, through
# any available Schema Validators for Ruby.
#
# They should be valid according to draft-4 ...
#
# The schema validators currently being considered are:
#
# https://github.com/ruby-json-schema/json-schema
# https://github.com/brandur/json_schema (note the underscore!)
# https://github.com/Soylent/jschema
#
# These are the three currently available ruby validators that
# support draft-4. (According to json-schema.org).
#
# Each has their quirks, we'll try to:
#    * use each to validate each fidor schema against the json-schema meta-schema
#    * try to load each fidor schema as a schema for validation.
#
require 'pathname'

module Validator
  class Base
    def validate_all
       @files_to_validate.each do |file|
        schema = File.read file
        puts "\nvalidating: #{file}"
        validate schema
        puts "\nusing #{file} for validation."
        use_for_validation schema
      end
    end
  end

  def self.find_all_schema
    # asssume we're running from rake and pwd is project root ...
    this_dir = File.dirname(__FILE__)
    repo_dir = Pathname.new(this_dir+"/../..").cleanpath.to_s

    Dir.glob("#{repo_dir}/schema/*/*.json")
  end


  def self.main validator
    case validator
      when :underscore
        puts "Running validation with JSON_Schema"
        Json_Schema.new find_all_schema
      when :dash
        puts "Running validation with JSON-Schema"
        JsonSchema.new find_all_schema
      when :jschema
        puts "Running validation with JSchema"
        JSchema.new find_all_schema
      else
        puts "Unknown validator: #{validator}"
    end
  end
end