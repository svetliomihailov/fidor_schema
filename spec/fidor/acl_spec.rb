require 'spec_helper'

describe Fidor::Acl do

  context 'read permissions' do

    it 'reads all json files' do
      res = Fidor::Acl.init
      expect(Fidor::Acl.registry).to_not be_empty
      permission_names = res.map{|i| i['name']}
      expect(permission_names).to include 'read_customer_address'
      expect(permission_names).to include 'read_user_email'
    end

    it 'flattens permissions' do
      res = Fidor::Acl.flat_perms_hash
      expect(res.keys).to include 'customers', 'transactions', 'users'
      expect(res['customers']).to include 'show'
    end

  end

  context 'init_objects' do
    it 'builds permission objects' do
      res = Fidor::Acl.init_objects
      expect(Fidor::Acl.object_registry).to_not be_empty
    end
  end

  context 'validate fields' do

    before do
      SchemaTools.schema_path = Fidor::Schema.path
      @schemas = SchemaTools::Reader.read_all Fidor::Schema.path
      Fidor::Acl.init_objects
    end

    it 'contains only fields defined in schema' do
      Fidor::Acl.object_registry.each do |permission|
        # find matching json schema
        schema = @schemas.detect{|schema| schema['name'] == permission.context.singularize }
        unless schema
          expect(schema).to be, "Field validation failed! Schema for #{permission.context} could not be found"
          next
        end
        schema_fields = schema['properties'].keys
        permission.fields.each do |perm_field|
          expect(schema_fields).to include(perm_field), "expected schema '#{schema['name']}' to have a '#{perm_field}' property in permission: '#{permission.name}'.\nAvailable #{schema['name']} fields:\n#{schema_fields}\n Please check the field-names in #{schema['name']}.json"
        end

      end
    end

    it 'uses all schema properties' do
      context_fields = {}  # all fields used in a context
      Fidor::Acl.object_registry.each do |permission|
        context_name = permission.context.singularize
        context_fields[ context_name ] ||= []
        context_fields[ context_name ] += permission.fields # use all fields
        context_fields[ context_name ].uniq!
      end

      # for each schema property check if it is used in the acl
      @schemas.each do |schema|
        acl_fields = context_fields[ schema['name'] ]
        next if acl_fields.blank?
        schema['properties'].keys.each do |schema_field|
          expect(acl_fields).to include(schema_field), "expected permissions for '#{schema['name']}' to include '#{schema_field}' in at least one permission.\nFields used across #{schema['name']} permissions:\n#{acl_fields}"
        end
      end
    end
  end

  context 'validate privileges' do

    before do
      @schemas = SchemaTools::Reader.read_all(Fidor::Schema.path)
      Fidor::Acl.init_objects
    end

    it 'contains only privileges/routes defined in schema' do
      Fidor::Acl.object_registry.each do |permission|
        # find matching json schema
        schema = @schemas.detect{|schema| schema['name'] == permission.context.singularize }
        next unless schema
        schema_privs = schema['links'].map{|i| i['rel']}
        # index => instances
        # show => self
        # destroy => destroy
        # create => create
        permission.privileges.each do |privilege|
          link_rel = case privilege
                       when 'index'
                         'instances'
                       when 'show'
                         'self'
                       when 'create', 'update', 'destroy', 'current'
                         privilege
                     end

          expect(schema_privs).to include(link_rel), "expected schema '#{schema['name']}' to have a link with rel '#{link_rel}'. Used in permission '#{permission.name}'.\nAvailable #{schema['name']} links:\n#{schema_privs}\n "
        end

      end
    end

  end

  context 'i18n' do
    it 'has all fields' do
      res = Fidor::Acl.i18n_field_keys
      # number changes whenever we add/remove fields from acl
      expect(res.length).to be 89
      expect(res).to include 'email:'
    end

    it 'finds missing' do
      res = Fidor::Acl.i18n_find_missing
    end

    xit 'adds missing' do # no spec here since it could screw up our lang files
      res = Fidor::Acl.i18n_add_missing
    end

  end

end