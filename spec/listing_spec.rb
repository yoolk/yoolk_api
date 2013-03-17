require 'spec_helper'

describe 'Portal' do
  before(:all) do
    YoolkApi.setup(
      domain_name: 'yellowpages-cambodia.dev:3000'
    )
    @listing = YoolkApi::Listing.find('kh1223')
  end

  context "Image Resources" do
    it "get attribute value" do
      @listing.alias_id.should == 'kh1223'
    end

    it "#logo should be instance of YoolkApi::Logo" do
      @listing.logo.should be_instance_of(YoolkApi::Logo)
    end

    it "#gallery_images should be an array of YoolkApi::GalleryImage" do
      @listing.gallery_images.should be_instance_of(Array)
      @listing.gallery_images[0].should be_instance_of(YoolkApi::GalleryImage)
    end

    it "#catalog_items should be an array of YoolkApi::CatalogItem" do
      @listing.catalog_items.should be_instance_of(Array)
      @listing.catalog_items[0].should be_instance_of(YoolkApi::CatalogItem)
    end

    it "#artworks should be an array of YoolkApi::Artwork" do
      @listing.artworks.should be_instance_of(Array)
      @listing.artworks[0].should be_instance_of(YoolkApi::Artwork)
    end
  end
end