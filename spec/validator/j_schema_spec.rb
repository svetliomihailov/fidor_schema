require 'spec_helper'
require 'validator'

describe Validator::JSchema do
  it 'validates schemas against the meta schema' do
    path = Fidor::Schema.path
    files = Dir.glob("#{path}/**/*.json")
    v = Validator::JSchema.new files
    v.validate_schemas
    expect(v.log[0]).to include('validate schema')
    # expect(v.errors).to be_empty
  end

  it 'validates schemas against blank data' do
    path = Fidor::Schema.path
    files = Dir.glob("#{path}/**/*.json")
    v = Validator::JSchema.new files
    v.validate_data
    expect(v.log[0]).to include('validate data')
    # expect(v.errors).to be_empty
  end
end