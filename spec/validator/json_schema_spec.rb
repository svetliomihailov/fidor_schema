require 'spec_helper'
require 'validator'

describe Validator::Json_Schema do
  it 'validates schemas against the meta schema' do
    path = Fidor::Schema.path
    files = Dir.glob("#{path}/**/*.json")
    v = Validator::Json_Schema.new files
    v.validate_schemas
    expect(v.log[0]).to include('validate schema')
    expect(v.errors).to be_empty
  end
end