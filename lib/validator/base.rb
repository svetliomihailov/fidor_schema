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
    # @return [Array<String>] file paths
    attr_accessor :files_to_validate

    # Run the given validator with all schema files
    def self.run(files)
      puts "Running validation with #{name} for #{files.length} schemas"
      v = new(files)
      v.validate_all
      puts v.log_fmt
      v
    end

    def validate_all
      validate_schemas
      validate_data
    end

    def validate_schemas
      files_to_validate.each do |file|
        schema = File.read file
        log << "validate schema: #{file}"
        validate schema
      end
    end

    def validate_data
      files_to_validate.each do |file|
        schema = File.read file
        log << "validate data against: #{file}"
        use_for_validation schema
      end
    end


    # Joins the logs before display
    def log_fmt
      res = []
      if errors.length > 0
        res << "#{errors.join("\n\n")}"
        res << "="*50
        res << "#{errors.length} with errors"
      end
      res << "#{success.uniq.length} Schemas passed"
      res.join("\n")
    end
    # @return [Array<String>] error schemas
    def errors
      @errors ||= []
    end
    # @return [Array<String>] test log
    def log
      @log ||= []
    end
    # @return [Array<String>] successfull schema titles
    def success
      @success ||= []
    end

  end

  def self.find_all_schema
    # asssume we're running from rake and pwd is project root ...
    this_dir = File.dirname(__FILE__)
    repo_dir = Pathname.new(this_dir+"/../..").cleanpath.to_s

    Dir.glob("#{repo_dir}/schema/**/*.json")
  end


  # @param [Symbol] validator to use
  def self.run(validator)
    case validator
      when :underscore
        Json_Schema.run find_all_schema
      when :dash
        JsonSchema.run find_all_schema
      when :jschema
        JSchema.run find_all_schema
      else
        puts "Unknown validator: #{validator}"
    end
  end
end