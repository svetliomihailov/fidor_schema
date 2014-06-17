require 'spec_helper'

describe Fidor::Acl do

  context 'read permissions' do

    it 'should read all json files' do
      res = Fidor::Acl.init
      expect(Fidor::Acl.registry).to_not be_empty
      expect(res.keys).to include 'read_customer_address'
      expect(res.keys).to include 'read_user_email'
    end

    it 'should flatten permissions' do
      res = Fidor::Acl.flat_perms_hash
      expect(res.keys).to include 'transfers', 'transactions', 'users'
      expect(res['customers']).to include 'current', 'show'
    end

  end

  context 'init_objects' do
    it 'builds permission objects' do
      res = Fidor::Acl.init_objects
      expect(Fidor::Acl.object_registry).to_not be_empty
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
          expect(schema_fields).to include(scope_field)
        end

      end
    end

  end

  context 'i18n' do
    it 'has all fields' do
      res = Fidor::Acl.i18n_field_keys
      expect(res.length).to be 52
      expect(res).to include 'email:'
    end
  end

end