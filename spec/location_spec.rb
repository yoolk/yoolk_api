require 'spec_helper'

describe 'Location' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'cambodiastaging.yoolk.com',
      per_page: 30
    )
  end

  context "Methods" do
    it "should return location by identity" do
      location = YoolkApi::Location.find('kh2')

      location.should be_an_instance_of(YoolkApi::Location)
      location.alias_id.should == 'kh2'
      location.name.should == 'Phnom Penh'
    end

    it "should return location which contains only id and alias_id" do
      location = YoolkApi::Location.find('kh2', fields: 'id,alias_id')

      location.should be_an_instance_of(YoolkApi::Location)
      location.attributes.keys.should == ["alias_id", "id"]
      location.id.should == '01834EE1-FA95-48DE-831A-3D3C05DD3AFC'
      location.alias_id.should == 'kh2'
    end
  end
end