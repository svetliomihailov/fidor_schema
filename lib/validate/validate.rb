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
require 'pathname'
require 'json-schema'
require 'json_schema'

module Fidor
  module SchemaValidation
    class Validator
      def validate_all
         @files_to_validate.each do |file|
          schema = File.read file
          puts "validating: #{file}"
          validate schema
        end
      end
    end
    class JsonDashSchemaValidator < Validator
      def initialize files_to_validate
        @files_to_validate = files_to_validate
        @meta_schema_fn    = "#{File.dirname(__FILE__)}/schema.json"
        validate_all
      end # init
      def validate schema
        begin
          JSON::Validator.validate!(@meta_schema_fn, schema, :strict => true)
        rescue
          puts $!
          puts "Failed!"
        else
          puts "Passed"
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
    end
     
    def self.find_all_schema
      # asssume we're running from rake and
      # pwd is project root ...
      this_dir = File.dirname(__FILE__)
      repo_dir = Pathname.new(this_dir+"/../..").cleanpath.to_s

      Dir.glob("#{repo_dir}/schema/*/*.json")
    end
    

    def self.main
      puts "JSON-Schema"
      JsonDashSchemaValidator.new find_all_schema
      puts "JSON_Schema"
      JsonUnderscoreSchemaValidator.new find_all_schema
    end
  end
end

