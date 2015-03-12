require 'json-schema'
# https://github.com/ruby-json-schema/json-schema
module Validator
  class JsonSchema < Base
    def initialize(files_to_validate)
      @files_to_validate = files_to_validate
      @meta_schema_path  = "#{File.dirname(__FILE__)}/schema.json"

      # need to know the base dir of the schema to resolve relative uris.
      # see below.
      @schemadir = File.dirname(@files_to_validate[0])
    end

    # @param [String] schema to test against the meta schema
    def validate(schema)
      schema_to_test = JSON.parse(schema)
      begin
        result = JSON::Validator.fully_validate(@meta_schema_path, schema_to_test)
        if !result || result.length == 0
          success << schema_to_test['title'] || schema_to_test.keys[0]
        else
          errors << "Schema validation failed: #{schema_to_test['title']}\n#{result.join("\n")}"
        end
      rescue => e
        errors << "Schema validation failed: #{schema_to_test['title']}\n#{e}"
        # puts e.backtrace
      end
    end

    def use_for_validation(schema)
      schema_to_test = JSON.parse(schema)

      # json-schema resolves relatives path relative to it's own "."
      # not relative to the file containing the reference ...
      base_dir = Dir.pwd

      begin
        Dir.chdir @schemadir
        data = {}
        result = JSON::Validator.fully_validate(schema_to_test, data)
        if !result || result.length == 0
          success << schema_to_test['title']
        else
          errors << "Data validation failed: #{schema_to_test['title']}\n#{result.join("\n")}"
        end
      ensure
        Dir.chdir base_dir
      end
    end
  end
end