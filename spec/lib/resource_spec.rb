require 'spec_helper'

describe 'Resource', :vcr do
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
      portal.domain_name.should == 'yellowpages-cambodia.dev'
      portal.address_templates.length.should == 3
      portal.address_templates[0].id.should == '346B9048-8755-11E0-A31D-123141003441'
    end
  end

  context "Association" do
    before(:all) do
      @portal = YoolkApi::Portal.current
    end

    it "should return locations (already included)" do
      @portal.locations.should be_an_instance_of(YoolkApi::Resource::Collection)
      @portal.locations.length.should == 25
    end

    it "should return listings (not included)" do
      @portal.listings.should be_an_instance_of(YoolkApi::Resource::Collection)

      @portal.listings.length.should == 25
    end

    it "should cache association after loaded" do
      @portal.instance_variable_get(:@categories_resource_collection).should be_nil

      @portal.categories

      @portal.instance_variable_get(:@categories_resource_collection).should be_an_instance_of(YoolkApi::Resource::Collection)
    end

    it "should return true if there is association data" do
      @portal.categories?.should be_true
    end
  end

  context "Chaining" do
    before(:each) do
      @portal = YoolkApi::Portal.current
    end

    it "should return paging data" do
      @portal.locations.total_entries.should == 31
      @portal.locations.total_pages.should == 2
      @portal.locations.per_page.should == 25
      @portal.locations.current_page.should == 1
      @portal.locations.next_page.should == 2
      @portal.locations.previous_page.should == nil
      @portal.locations.offset.should == 1
      @portal.locations.page_offset.should == [1,25]
    end

    it "#loaded? return true after loaded" do
      @portal.listings.loaded?.should == false
      @portal.listings.to_a

      @portal.listings.loaded?.should == true
    end

    it "#loaded? return false after changing query" do
      @portal.listings.to_a
      @portal.listings.loaded?.should == true

      @portal.listings.per_page(1).to_a
      @portal.listings.per_page(1).loaded?.should == true

      @portal.listings.loaded?.should == false
      @portal.listings.to_a
      @portal.listings.loaded?.should == true

      @portal.listings.per_page(1).to_a
      @portal.listings.per_page(1).loaded?.should == true
    end

    it "should chaining the query: #per_page" do
      relation = @portal.categories.per_page(10)

      relation.query.should == { per_page: 10 }
    end

    it "should chaining the query: #page" do
      relation = @portal.categories.page(10)

      relation.query.should == { page: 10 }
    end

    it "should chaining the query: #q" do
      relation = @portal.categories.q('hello')

      relation.query.should == { q: 'hello' }
    end

    it "should chaining the query: #page, #per_page, #q" do
      relation = @portal.categories.page(2).per_page(5).q('hello')

      relation.query.should == { page: 2, per_page: 5, q: 'hello' }
    end

    it "should overwrite the existing query: #q" do
      relation = @portal.categories.q('hello').q('hi')

      relation.query.should == { q: 'hi' }
    end

    it "should overwrite the existing query: #page" do
      relation = @portal.categories.page(1).page(2)

      relation.query.should == { page: 2 }
    end

    it "should overwrite the existing query: #per_page" do
      relation = @portal.categories.per_page(10).per_page(20)

      relation.query.should == { per_page: 20 }
    end

    it "should combine the existing query: #fields" do
      relation = @portal.categories.fields('id').fields('alias_id')

      relation.query.should == { fields: 'id,alias_id' }
    end

    it "should return api_path with query_string" do
      relation = @portal.categories.page(2).per_page(1).fields('id').fields('alias_id').q('hello')

      relation.to_api_path.should == '/categories?fields=id%2Calias_id&page=2&per_page=1&q=hello'
    end

    it "should load resource with the specified query options" do
      listings = @portal.listings.page(2).per_page(1).fields('id').fields('alias_id').q('hello').to_a
      
      listings[0].attributes.keys.should == ['alias_id', 'id']
    end
  end
  
  describe '#respond_to' do
    let(:resource) { MySubResource.new(greeting: 'Welcome') } 
   
    it 'responds to method name' do
      expect(resource.respond_to?(:hello)).to be_true 
    end
    
    it 'responds attributes key' do
      expect(resource.respond_to?(:greeting)).to be_true
    end
  end
end

class MySubResource < YoolkApi::Resource 
  def hello
    "Hello World!"
  end
end

