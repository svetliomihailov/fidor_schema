require 'jschema'
module Validator
  class JSchema < Base

    def initialize(files_to_validate)
      @files_to_validate = files_to_validate
      schema_data = File.read("#{File.dirname(__FILE__)}/schema.json")
      schema_json = JSON.parse(schema_data)
      @meta_schema = ::JSchema.build(schema_json)
    end

    def validate(schema)
      schema_to_test = JSON.parse(schema)
      result = @meta_schema.validate schema_to_test
      if !result || result.length == 0
        success << schema_to_test['title'] || schema_to_test.keys[0]
      else
        errors << "Schema validation failed: #{schema_to_test['title']}\n#{result.join("\n")}"
      end
    end

    def use_for_validation(schema)
      schema_to_test = JSON.parse(schema)
      begin
       ::JSchema.build(schema_to_test)
      rescue
        errors << "Data validation failed: #{schema_to_test['title']}\n#{$!}"
        # puts $!.backtrace
      else
        success << schema_to_test['title'] || schema_to_test.keys[0]
      end
    end
  end
end