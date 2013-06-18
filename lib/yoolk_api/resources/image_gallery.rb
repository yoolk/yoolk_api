module YoolkApi
  class ImageGallery < Resource
    attr_reader :gallery_images

    def initialize(attributes={}, gallery_images=[])
      super(attributes)
      @gallery_images = gallery_images
    end

    class << self
      undef_method :find
    end
  end
end