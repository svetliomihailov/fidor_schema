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
require 'json-schema'
require 'json_schema'
require 'jschema'

module Fidor
  module SchemaValidation
    
    class Validator # Base
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
    
    # https://github.com/ruby-json-schema/json-schema
    class JsonDashSchemaValidator < Validator
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
        baseDirectory = Dir.pwd

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
          Dir.chdir baseDirectory
        end
      end
    end

    class JsonUnderscoreSchemaValidator < Validator
      def initialize files_to_validate
        @files_to_validate = files_to_validate 
        schema_data = File.read("#{File.dirname(__FILE__)}/schema.json")
        schema_json = JSON.parse(schema_data)
        @schema = JsonSchema.parse!(schema_json)
        validate_all
      end 

      def validate schema
        begin
          schema_to_test = JSON.parse(schema)
          @schema.validate! schema_to_test
          puts "Passed validation against meta-schema!"
          JsonSchema.parse!(schema_to_test)
        rescue
          puts $!
          puts "Failed!"
        else
          puts "Passed!"
        end
      end
      def use_for_validation schema
        begin
         schema_to_test = JSON.parse(schema)
         JsonSchema.parse!(schema_to_test)
        rescue
          puts $!
          puts "Failed"
        else
          puts "Passed!"
        end
      end 
    end

    class JSchemaValidator < Validator
      def initialize files_to_validate
        @files_to_validate = files_to_validate
        schema_data = File.read("#{File.dirname(__FILE__)}/schema.json")
        schema_json = JSON.parse(schema_data)
        @schema = JSchema.build(schema_json)
        validate_all
      end
      def validate schema
        schema_to_test = JSON.parse(schema)
        results = @schema.validate schema_to_test
        if !results || results.length == 0 
          puts "Passed!"
        else
          puts "Failed!"
          puts results
        end
      end
      def use_for_validation schema
        schema_to_test = JSON.parse(schema)
        begin
         JSchema.build(schema_to_test)
        rescue
          puts "Failed!"
          puts $!
          # puts $!.backtrace
        else
          puts "Passed!"
        end
      end
    end
    
    def self.find_all_schema
      # asssume we're running from rake and
      # pwd is project root ...
      this_dir = File.dirname(__FILE__)
      repo_dir = Pathname.new(this_dir+"/../..").cleanpath.to_s

      Dir.glob("#{repo_dir}/schema/*/*.json")
    end
    

    def self.main validator
      case validator
        when :underscore
          puts "Running validation with JSON_Schema"
          JsonUnderscoreSchemaValidator.new find_all_schema
        when :dash
          puts "Running validation with JSON-Schema"
          JsonDashSchemaValidator.new find_all_schema
        when :jschema
          puts "Running validation with JSchema"
          JSchemaValidator.new find_all_schema
        else
          puts "Unknown validator: #{validator}"
      end
      
    end
  end
end

