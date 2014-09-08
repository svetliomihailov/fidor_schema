require 'spec_helper'
describe Fidor::Auth do

  let(:guard) { Fidor::Auth::Guard.new }
  let(:all_perms) { Fidor::Acl.flat_perms_hash }

  it 'should add permissions' do
    guard.add_permissions(1, all_perms)

    expect(guard.effective_permissions.length).to be all_perms.length
  end

  it 'should reduce permissions on lower level' do
    reduced_perms = {'sepa_credit_transfers'=>['index', 'show'],
                     'users' =>['show'],
                     'dropped'=>['key_not_on_level_above']}
    guard.add_permissions(1, all_perms)
    # second level e.g. coming from an app
    guard.add_permissions(2, reduced_perms)

    expect(guard.effective_permissions.length).to be 2
    expect(guard.effective_permissions).not_to have_key 'dropped'
    expect(guard.effective_permissions['sepa_credit_transfers']).to eql ['index', 'show']
  end
end