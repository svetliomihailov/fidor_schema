require 'json_schema'
module Validator
  class Json_Schema < Base

    def initialize files_to_validate
      @files_to_validate = files_to_validate
      schema_data = File.read("#{File.dirname(__FILE__)}/schema.json")
      schema_json = JSON.parse(schema_data)
      @schema = ::JsonSchema.parse!(schema_json)
      @errors, @success = [], []
    end

    # @param [String] schema to test against the meta schema
    def validate(schema)
      schema_to_test = JSON.parse(schema)
      begin
        @schema.validate! schema_to_test
      rescue
        errors << "Schema validation failed: #{schema_to_test['title']}\n#{$!}"
      else
        success << File.basename(schema)
      end
    end

    def use_for_validation(schema)
       schema_to_test = JSON.parse(schema)
      begin
       ::JsonSchema.parse!(schema_to_test)
      rescue
        errors << "Data validation failed: #{schema_to_test['title']}\n#{$!}"
      else
        success << schema_to_test['title']
      end
    end

  end
end