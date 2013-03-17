module YoolkApi
  class ImageResource
    include ResourceModel

    def images(type=nil)
      if type.nil?
        attributes['images']
      else
        attributes['images'].find { |image| image.type == type.to_s }
      end
    end
  end
end