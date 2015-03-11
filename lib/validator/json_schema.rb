require 'json_schema'
module Validator
  class Json_Schema < Base
    attr_accessor :errors, :success

    def initialize files_to_validate
      @files_to_validate = files_to_validate
      schema_data = File.read("#{File.dirname(__FILE__)}/schema.json")
      schema_json = JSON.parse(schema_data)
      @schema = ::JsonSchema.parse!(schema_json)
      @errors, @success = [], []
      validate_all
    end

    def validate schema
      begin
        schema_to_test = JSON.parse(schema)
        @schema.validate! schema_to_test
        # puts "Passed validation against meta-schema!"
        ::JsonSchema.parse!(schema_to_test)
      rescue
        puts $!
        puts "Failed!"
      else
        @success << '.'
      end
    end

    def use_for_validation schema
      begin
       schema_to_test = JSON.parse(schema)
       ::JsonSchema.parse!(schema_to_test)
      rescue
        puts $!
        puts "Failed"
      else
        @success << '.'
      end
    end
  end
end