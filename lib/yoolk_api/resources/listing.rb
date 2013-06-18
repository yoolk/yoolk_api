module YoolkApi
  class Listing < Resource
    has_many :categories, class: 'Category'
    attr_reader :logo, :artworks, :catalog_items, :gallery_images, :people
    attr_reader :image_galleries

    def initialize(attributes)
      super
      initialize_with_collections(attributes)
    end

    def catalog_items_with_images
      catalog_items.select { |catalog_item| catalog_item.images.present? }
    end

    private
    def initialize_with_collections(attributes)
      logo             = attributes['logo']
      artworks         = attributes['artworks'] || []
      catalog_items    = attributes['catalog_items'] || []
      gallery_images   = attributes['gallery_images'] || []
      people           = attributes['people'] || []
      image_galleries  = attributes['image_galleries'] || []
      @logo            = logo.present? ? YoolkApi::Logo.new(logo) : nil
      @artworks        = artworks.collect { |artwork| YoolkApi::Artwork.new(artwork) }
      @catalog_items   = catalog_items.collect { |catalog_item| YoolkApi::CatalogItem.new(catalog_item) }
      @gallery_images  = gallery_images.collect { |gallery_image| YoolkApi::GalleryImage.new(gallery_image) }
      @people          = people.collect { |person| YoolkApi::Person.new(person) }

      # work out on nested relation: image_gallery and gallery_images
      group_by         = @gallery_images.group_by { |gallery_image| gallery_image.image_gallery.id }
      @image_galleries = image_galleries.collect do |image_gallery|
        YoolkApi::ImageGallery.new(image_gallery, group_by[image_gallery['id']])
      end
    end
  end
end