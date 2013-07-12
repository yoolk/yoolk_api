module YoolkApi
  class Listing < Resource
    has_many :categories, class: 'Category'
    attr_reader :logo, :artworks, :catalog_items, :gallery_images, :people
    attr_reader :image_galleries

    def logo
      return @logo if @logo

      logo  = attributes['logo']
      @logo = logo.present? ? YoolkApi::Logo.new(logo) : nil
      @logo
    end

    def artworks
      return @artworks if @artworks

      artworks  = attributes['artworks'] || []
      @artworks = artworks.collect { |artwork| YoolkApi::Artwork.new(artwork) }
      @artworks
    end

    def catalog_items
      return @catalog_items if @catalog_items

      catalog_items  = attributes['catalog_items'] || []
      @catalog_items = catalog_items.collect { |catalog_item| YoolkApi::CatalogItem.new(catalog_item) }
      @catalog_items
    end

    def catalog_items_with_images
      catalog_items.select { |catalog_item| catalog_item.images.present? }
    end

    def people
      return @people if @people

      people  = attributes['people'] || []
      @people = people.collect { |person| YoolkApi::Person.new(person) }
      @people
    end

    def gallery_images
      return @gallery_images if @gallery_images

      gallery_images  = attributes['gallery_images'] || []
      @gallery_images = gallery_images.collect { |gallery_image| YoolkApi::GalleryImage.new(gallery_image) }
      @gallery_images
    end

    def image_galleries
      return @image_galleries if @image_galleries

      # work out on nested relation: image_gallery and gallery_images
      image_galleries  = attributes['image_galleries'] || []
      group_by         = gallery_images.group_by { |gallery_image| gallery_image.image_gallery.id }
      @image_galleries = image_galleries.collect do |image_gallery|
        YoolkApi::ImageGallery.new(image_gallery, group_by[image_gallery['id']])
      end
      @image_galleries
    end
  end
end