require 'spec_helper'

describe Fidor::Permission do

  before do
    @acls = Fidor::Acl.init
  end
  context 'from_hash' do
    it 'returns new object' do
      permission = Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer']
      expect(permission.name).to eq 'readwrite_transfer'
      expect(permission.context).to eq 'transfers'
      expect(permission.privileges).to be
      expect(permission.fields).to be
    end
  end

  context 'translate' do
    it 'translates name' do
      res = Fidor::Acl.init
      permission = Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer']
      expect(permission.translated_name).to eq I18n.t('permission_names.readwrite_transfer')
    end

    it 'translates fields' do
      res = Fidor::Acl.init
      permission = Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer']
      expect(permission.translated_fields).to include 'Account ID'
    end
  end

end