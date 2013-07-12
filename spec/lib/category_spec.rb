require 'spec_helper'

describe 'Category', :vcr do
  context "Methods" do
    it "#parent should return parent category" do
      category = YoolkApi::Category.find('kh12093')

      category.parent.should be_instance_of(YoolkApi::Category)
      category.parent.alias_id.should == 'kh77'
    end

    it "#parent should return nil when it doesn't have parent_id field" do
      category = YoolkApi::Category.find('kh12093', fields: 'id,name')
      
      category.parent.should be_nil
    end

    it "#parent should return nil when it doesn't have parent" do
      category = YoolkApi::Category.find('kh77')

      category.parent.should be_nil
    end
  end
end