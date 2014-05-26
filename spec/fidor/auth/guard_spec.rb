require 'spec_helper'
describe Fidor::Auth do

  it 'should add permissions' do
    guard = Fidor::Auth::Guard.new
    all_perms = Fidor::Acl.flat_perms_hash
    # perm1 = res = Fidor::Acl.init
    guard.add_permissions(1, all_perms)
    guard.effective_permissions.length.should == all_perms.length
  end

  it 'should reduce permissions on lower level' do
    guard = Fidor::Auth::Guard.new
    all_perms = Fidor::Acl.flat_perms_hash
    reduced_perms = {'transfers'=>['index', 'show'],
                     'users' =>['show'],
                     'dropped'=>['key_not_on_level_above']}
    guard.add_permissions(1, all_perms)
    # second level e.g. coming from an app
    guard.add_permissions(2, reduced_perms)
    guard.effective_permissions.length.should == 2
    guard.effective_permissions['dropped'].should_not be
    guard.effective_permissions['transfers'].should == ['index', 'show']
  end
end