module YoolkApi
  class ImageGallery < SubResource
    attr_reader :gallery_images

    def initialize(attributes={}, gallery_images=[])
      super(attributes)
      @gallery_images = gallery_images
    end
  end
end