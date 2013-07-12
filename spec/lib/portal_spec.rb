require 'spec_helper'

describe 'Portal', :vcr do
  context "Methods" do
    it "should not have method find" do
      YoolkApi::Portal.methods.should_not include(:find)
    end

    it "should return currency_code" do
      portal = YoolkApi::Portal.current

      portal.currency_code.should == 'USD'
    end
  end
end