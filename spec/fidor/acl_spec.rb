require 'spec_helper'

describe Fidor::Acl do

  context 'read permissions' do

    it 'should read all json files' do
      res = Fidor::Acl.read
      Fidor::Acl.registry.should_not be_empty
      res.keys.should include 'read_customer_address'
      res.keys.should include 'read_user_email'
    end


  end
end