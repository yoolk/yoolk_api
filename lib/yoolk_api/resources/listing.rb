module YoolkApi
  class Listing < Resource
    has_many     :categories, class_name: 'Category'
    sub_resource :logo, class_name: 'Logo'
    sub_resource :artworks, class_name: 'Artwork'
    sub_resource :catalog_items, class_name: 'CatalogItem'
    sub_resource :people, class_name: 'Person'
    sub_resource :gallery_images, class_name: 'GalleryImage'
    sub_resource :image_galleries, class_name: 'ImageGallery', contains: :gallery_images
    sub_resource :products, class_name: 'Product'
    sub_resource :product_categories, class_name: 'Product::Category', contains: :products
    sub_resource :product_brands, class_name: 'Product::Brand', contains: :products
    sub_resource :foods, class_name: 'Food'
    sub_resource :food_categories, class_name: 'Food::Category', contains: :foods
    sub_resource :menu_sources, class_name: 'Food::MenuSource'
    sub_resource :instant_website, class_name: 'InstantWebsite'
    sub_resource :portal, class_name: 'Portal'

    def self.find_by_instant_website(website, query={})
      member YoolkApi.client.get(api_path(website, query))
    end

    def catalog_items_with_images
      catalog_items.select { |catalog_item| catalog_item.images.present? }
    end
  end
end
