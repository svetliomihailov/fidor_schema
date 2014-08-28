require 'spec_helper'

describe Fidor::Permission do

  before do
    @acls = Fidor::Acl.init
  end

  let(:permission) { Fidor::Permission.from_hash 'readwrite_transfer', @acls['readwrite_transfer'] }

  describe '.from_hash' do
    it 'returns new object' do
      expect(permission.name).to eq 'readwrite_transfer'
      expect(permission.context).to eq 'transfers'
      expect(permission.privileges).to be
      expect(permission.fields).to be
    end
  end

  describe 'translation' do
    describe '.translated_name' do
      subject { permission.translated_name }

      it { should eq I18n.t('permission_names.readwrite_transfer') }
    end

    describe '.translated_fields' do
      subject { permission.translated_fields }

      it { should include 'Account ID' }
    end
  end

end