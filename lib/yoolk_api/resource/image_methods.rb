module YoolkApi
  module Resource::ImageMethods
    extend ActiveSupport::Concern

    included do

      def images(type=nil)
        if type.nil?
          attributes['images']
        else
          attributes['images'].find { |image| image.type == type.to_s } if attributes['images']
        end
      end
    end
  end
end