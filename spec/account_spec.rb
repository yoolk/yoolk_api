require 'spec_helper'

describe 'Account' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'yellowpages-cambodia.dev:3000'
    )
  end

  context "Methods" do
    it "should not have method find" do
      YoolkApi::Account.methods.should_not include(:find)
    end

    it "should return info about current account" do
      account = YoolkApi::Account.me(auth_token: 'gTq7dHBUMzLxGv3oYNiy')

      account.email.should == 'chamnap@yoolk.com'
    end
  end
end