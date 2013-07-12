module YoolkApi
  class Listing < Resource
    has_many :categories, class: 'Category'

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

    def products
      return @products if @products

      products  = attributes['products'] || []
      @products = products.collect { |product| YoolkApi::Product.new(product) }
      @products
    end

    def product_categories
      return @product_categories if @product_categories

      product_categories  = attributes['product_categories'] || []
      group_by            = products.group_by { |product_category| product_category.category.id }
      @product_categories = product_categories.collect do |product_category| 
        YoolkApi::Product::Category.new(product_category, group_by[product_category['id']])
      end
      @product_categories
    end

    def product_brands
      return @product_brands if @product_brands

      product_brands  = attributes['product_brands'] || []
      group_by        = products.group_by { |product_brand| product_brand.brand.id }
      @product_brands = product_brands.collect do |product_brand| 
        YoolkApi::Product::Brand.new(product_brand, group_by[product_brand['id']])
      end
      @product_brands
    end
  end
end