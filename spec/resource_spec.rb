require 'spec_helper'

describe 'Resource' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'cambodiastaging.yoolk.com',
      per_page: 30
    )
  end

  it "returns resource name" do
    YoolkApi::Portal.resource_name.should == 'portals'
  end

  it "fetches data" do
    portal = YoolkApi::Portal.current

    portal.should be_an_instance_of(YoolkApi::Portal)
  end

  it "access its attributes" do
    portal = YoolkApi::Portal.current

    portal.attributes.should be_an_instance_of(Hashie::Mash)
    portal.domain_name.should == 'cambodiastaging.yoolk.com'
    portal.address_templates.length.should == 3
    portal.address_templates[0].id.should == '346B9048-8755-11E0-A31D-123141003441'
  end
end