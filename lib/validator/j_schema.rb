require 'jschema'
module Validator
  class JSchema < Base

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
end