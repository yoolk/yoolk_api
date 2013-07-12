require 'spec_helper'

describe 'Listing', :vcr do
  before(:all) do
    @listing = YoolkApi::Listing.find('kh1223')
  end

  context "Image Resources", :vcr do
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

  context "ImageGallery" do
    it "#image_galleries should be an array of YoolkApi::ImageGallery" do
      @listing.image_galleries.should be_instance_of(Array)
      @listing.image_galleries[0].should be_instance_of(YoolkApi::ImageGallery)
    end

    it "#gallery_images should be an array of YoolkApi::GalleryImage" do
      image_gallery = @listing.image_galleries[0]

      image_gallery.gallery_images.should be_instance_of(Array)
      image_gallery.gallery_images[0].should be_instance_of(YoolkApi::GalleryImage)
    end
  end
end