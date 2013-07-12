module YoolkApi
  class Product < Resource
    autoload :Photo,            'yoolk_api/resources/product/photo'
    autoload :Category,         'yoolk_api/resources/product/category'
    autoload :Brand,            'yoolk_api/resources/product/brand'

    def photos
      return @photos if @photos

      photos  = attributes['photos'] || []
      @photos = photos.collect { |photo| Photo.new(photo) }
      @photos
    end
  end
end