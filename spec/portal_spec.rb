require 'spec_helper'

describe 'Portal' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'cambodiastaging.yoolk.com',
      per_page: 30
    )
  end

  it "should not have method find" do
    YoolkApi::Portal.methods.should_not include(:find)
  end

  it "should return currency_code" do
    portal = YoolkApi::Portal.current

    portal.currency_code.should == 'USD'
  end
end