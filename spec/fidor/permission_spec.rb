require 'spec_helper'

describe Fidor::Permission do

  before do
    @acls = Fidor::Acl.init
  end
  context 'from_hash' do
    it 'returns new object' do
      permission = Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer']
      permission.name.should == 'readwrite_transfer'
      permission.context.should == 'transfers'
      permission.privileges.should be
      permission.fields.should be
    end
  end

  context 'translate' do
    it 'translates name' do
      res = Fidor::Acl.init
      permission = Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer']
      permission.translated_name.should == I18n.t('permission_names.readwrite_transfer')
    end
  end

end