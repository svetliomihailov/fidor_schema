require 'spec_helper'

describe Fidor::Acl do

  context 'read permissions' do

    it 'should read all json files' do
      res = Fidor::Acl.read
      Fidor::Acl.registry.should_not be_empty
      res.keys.should include 'read_customer_address'
      res.keys.should include 'read_user_email'
    end

  end

  context 'validate fields' do

    it 'should only contain fields defined in schema' do
      schemas = SchemaTools::Reader.read_all(Fidor::Schema.path)
      Fidor::Acl.read
      Fidor::Acl.registry.each do |scope_name, scope|
        # find matching json schema
        schema = schemas.detect{|schema| schema['name'] == scope['context'].singularize }
        schema_fields = schema['properties'].keys

        scope['fields'].each do |scope_field|
          schema_fields.should include(scope_field)
        end

      end
    end

  end

end