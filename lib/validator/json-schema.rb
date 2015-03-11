require 'json-schema'
# https://github.com/ruby-json-schema/json-schema
module Validator
  class JsonSchema < Base
    def initialize files_to_validate
      @files_to_validate = files_to_validate
      @meta_schema_fn    = "#{File.dirname(__FILE__)}/schema.json"

      # need to know the base dir of the schema to resolve relative uris.
      # see below.
      @schemadir = File.dirname(@files_to_validate[0])

      validate_all
    end # init

    def validate schema
      begin
        results = JSON::Validator.fully_validate(@meta_schema_fn, schema)
        if !results || results.length == 0
          puts "Passed!"
        else
          puts "Failed!"
          puts results
        end
      rescue
        puts "Failed! Error..."
        puts $!
        puts $!.backtrace
      end
    end

    def use_for_validation schema
      # json-schema resolves relatives path relative to it's own "."
      # not relative to the file containing the reference ...
      base_dir = Dir.pwd

      begin
        Dir.chdir @schemadir
        data = {}
        results = JSON::Validator.fully_validate(schema, data)
        if !results || results.length == 0
          puts "Passed!"
        else
          puts "Failed!"
          puts results
        end
      ensure
        Dir.chdir base_dir
      end
    end
  end
end