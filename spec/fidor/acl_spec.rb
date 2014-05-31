require 'spec_helper'

describe Fidor::Acl do

  context 'read permissions' do

    it 'should read all json files' do
      res = Fidor::Acl.init
      Fidor::Acl.registry.should_not be_empty
      res.keys.should include 'read_customer_address'
      res.keys.should include 'read_user_email'
    end

    it 'should flatten permissions' do
      res = Fidor::Acl.flat_perms_hash
      Fidor::Acl.registry.should_not be_empty
      res.keys.should include 'transfers', 'transactions', 'users'
      res['customers'].should include 'current', 'show'
    end

  end

  context 'init_objects' do
    it 'builds permission objects' do
      res = Fidor::Acl.init_objects
      Fidor::Acl.object_registry.should_not be_empty
    end
  end

  context 'validate fields' do

    it 'should only contain fields defined in schema' do
      schemas = SchemaTools::Reader.read_all(Fidor::Schema.path)
      Fidor::Acl.init
      Fidor::Acl.registry.each do |scope_name, scope|
        # find matching json schema
        schema = schemas.detect{|schema| schema['name'] == scope['context'].singularize }
        schema_fields = schema['properties'].keys

        scope['fields'].each do |scope_field|
          next if scope_field == '_all'
          schema_fields.should include(scope_field)
        end

      end
    end

  end

end