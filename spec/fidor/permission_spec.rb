require 'spec_helper'
require 'json'

describe Fidor::Permission do

  let(:acls) { Fidor::Acl.init }
  let(:readwrite_transfer) { acls['readwrite_transfer'] }
  let(:permission) { Fidor::Permission.from_hash 'readwrite_transfer', readwrite_transfer }

  describe '.from_hash' do
    describe 'permission.name' do
      subject { permission.name }

      it { should eq 'readwrite_transfer' }
    end

    describe 'permission.context' do
      subject { permission.context }

      it { should eq readwrite_transfer['context'] }
    end

    describe 'permission.privileges' do
      subject { permission.privileges }

      it { should eq readwrite_transfer['privileges'] }
    end

    describe 'permission.fields' do
      subject { permission.fields }

      it { should eq readwrite_transfer['fields'] }
    end
  end

  describe '.to_json' do
    subject { JSON.parse permission.to_json }

    let(:expectation) { { 'name' => 'readwrite_transfer' }.merge readwrite_transfer }

    it { should eql expectation }
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