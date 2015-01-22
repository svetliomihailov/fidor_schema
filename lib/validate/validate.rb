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

module Fidor
  module SchemaValidation
    
    class JsonDashSchemaValidator
      def initialize files_to_validate
        @files_to_validate = files_to_validate
        @meta_schema_fn    = "#{File.dirname(__FILE__)}/schema.json"
        validate_all
      end # init
      def validate_all
        @files_to_validate.each do |file|
          schema = File.read file
          puts "validating: #{file}"
          validate schema
        end
      end
      def validate schema
        begin
          JSON::Validator.validate!(@meta_schema_fn, schema, :strict => true)
        rescue
          puts $!
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
      JsonDashSchemaValidator.new find_all_schema
    end
  end
end

