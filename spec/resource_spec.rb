require 'spec_helper'

describe 'Resource' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'cambodiastaging.yoolk.com',
      per_page: 30
    )
  end

  context "Methods" do
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

  context "Association" do
    before(:all) do
      @portal = YoolkApi::Portal.current
    end

    it "should return locations (already included)" do
      @portal.locations.should be_an_instance_of(OpenStruct)
      @portal.locations.all.count.should == 25
    end

    it "should return listings (not included)" do
      @portal.listings.should be_an_instance_of(OpenStruct)
      @portal.listings.all.count.should == 25
    end

    it "should cache when loaded" do
      @portal.instance_variable_get(:@categories_has_many_instances).should be_nil

      @portal.categories

      @portal.instance_variable_get(:@categories_has_many_instances).should be_an_instance_of(OpenStruct)
    end

    it "should return paging data" do
      @portal.locations.total_entries.should == 31
      @portal.locations.total_pages.should == 2
      @portal.locations.per_page.should == 25
      @portal.locations.current_page.should == 1
    end
  end
end