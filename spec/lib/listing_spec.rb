require 'spec_helper'

describe 'Listing', 'Logo, CatalogItem, Artwork', :vcr do
  let(:listing) { YoolkApi::Listing.find('kh1223') }

  it "get attribute value" do
    listing.alias_id.should == 'kh1223'
  end

  it "#logo should be instance of YoolkApi::Logo" do
    listing.logo.should be_instance_of(YoolkApi::Logo)
  end

  it "#catalog_items should be an array of YoolkApi::CatalogItem" do
    listing.catalog_items.should be_instance_of(Array)
    listing.catalog_items[0].should be_instance_of(YoolkApi::CatalogItem)
  end

  it "#artworks should be an array of YoolkApi::Artwork" do
    listing.artworks.should be_instance_of(Array)
    listing.artworks[0].should be_instance_of(YoolkApi::Artwork)
  end
end

describe 'Listing', 'ImageGallery & GalleryImage', :vcr do
  let(:listing) { YoolkApi::Listing.find('kh1223') }

  it "#gallery_images should be an array of YoolkApi::GalleryImage" do
    listing.gallery_images.should be_instance_of(Array)
    listing.gallery_images[0].should be_instance_of(YoolkApi::GalleryImage)
  end

  it "#image_galleries should be an array of YoolkApi::ImageGallery" do
    listing.image_galleries.should be_instance_of(Array)
    listing.image_galleries[0].should be_instance_of(YoolkApi::ImageGallery)
  end

  it "#image_galleries#gallery_images should be an array of YoolkApi::GalleryImage" do
    image_gallery = listing.image_galleries[0]

    image_gallery.gallery_images.should be_instance_of(Array)
    image_gallery.gallery_images[0].should be_instance_of(YoolkApi::GalleryImage)
  end
end

describe 'Listing', 'Product::Category, Product::Brand, Product::Photo, and Product', :vcr do
  let(:listing) { YoolkApi::Listing.find('kh11849') }

  it "#products should be an array of YoolkApi::Product" do
    listing.products.should be_instance_of(Array)
    listing.products[0].should be_instance_of(YoolkApi::Product)
  end

  it "#products.#photos should be an array of YoolkApi::Product" do
    product = listing.products[0]

    product.photos.should be_instance_of(Array)
    product.photos[0].should be_instance_of(YoolkApi::Product::Photo)
  end

  it "#product_categories should be an array of YoolkApi::Product::Category" do
    listing.product_categories.should be_instance_of(Array)
    listing.product_categories[0].should be_instance_of(YoolkApi::Product::Category)
  end

  it "#product_categories.#products should be an array of YoolkApi::Product" do
    product_category = listing.product_categories[0]

    product_category.products.should be_instance_of(Array)
    product_category.products[0].should be_instance_of(YoolkApi::Product)
  end

  it "#product_brands should be an array of YoolkApi::Product::Brand" do
    listing.product_brands.should be_instance_of(Array)
    listing.product_brands[0].should be_instance_of(YoolkApi::Product::Brand)
  end

  it "#product_brands.#products should be an array of YoolkApi::Product" do
    product_brand = listing.product_brands[0]

    product_brand.products.should be_instance_of(Array)
    product_brand.products[0].should be_instance_of(YoolkApi::Product)
  end
end

describe 'Listing', 'InstantWebsite', :vcr do
  let(:listing) { YoolkApi::Listing.find('kh8022') }
  subject       { listing.instant_website }

  it "#instant_website should be an hash of YoolkApi::InstantWebsite" do
    subject.should be_instance_of(YoolkApi::InstantWebsite)
    subject.id.should == 2
    subject.domain_name.should == 'yellow-tower.com'
    subject.google_analytics_key.should == 'UA-42159257-17'
    subject.is_live.should == false
  end

  it "#template should be an hash of YoolkApi::InstantWebsite::Template" do
    subject.template.should be_instance_of(YoolkApi::InstantWebsite::Template)
    subject.template.id.should == 26
    subject.template.name.should == 'basic_business'
  end
end

