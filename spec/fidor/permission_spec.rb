require 'spec_helper'
require 'json'

describe Fidor::Permission do

  let(:acls) { Fidor::Acl.init }
  let(:readwrite_transfer) { acls['readwrite_transfer'] }
  let(:permission) { Fidor::Permission.from_hash 'readwrite_transfer', readwrite_transfer }

  describe '.from_hash' do
    it 'includes the acls values' do
      expect(permission.name).to eq 'readwrite_transfer'

      ['context', 'privileges', 'fields'].each do |field|
        expect(permission.send(field)).to eq readwrite_transfer[field]
      end
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