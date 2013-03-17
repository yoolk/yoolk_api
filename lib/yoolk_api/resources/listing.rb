module YoolkApi
  class Listing < Resource
    attr_reader :logo, :artworks, :catalog_items, :gallery_images
    has_many :categories, class: 'Category'

    def initialize(attributes)
      super
      @logo           = YoolkApi::Logo.new(attributes['logo'])
      @artworks       = attributes['artworks'].collect { |artwork| YoolkApi::Artwork.new(artwork) }
      @catalog_items  = attributes['catalog_items'].collect { |catalog_item| YoolkApi::CatalogItem.new(catalog_item) }
      @gallery_images = attributes['gallery_images'].collect { |gallery_image| YoolkApi::GalleryImage.new(gallery_image) }
    end

    def catalog_items_with_images
      catalog_items.select { |catalog_item| catalog_item.images.present? }
    end
  end
end