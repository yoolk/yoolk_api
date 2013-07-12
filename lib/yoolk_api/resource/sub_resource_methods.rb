module YoolkApi
  module Resource::SubResourceMethods
    extend ActiveSupport::Concern

    included do
      def klass_for_sub_resource(options)
        klass_name = options[:class_name]
        raise "Missing class name of sub_resource model. Provide with class_name: 'MyClass'." unless klass_name.present?
        
        self.class.klass_from_string(klass_name)
      end
    end

    module ClassMethods
      def sub_resource(sub_resource_name, options={})
        ## sample

        # def image_galleries
        #   return @image_galleries if @image_galleries

        #   # work out on nested relation: image_gallery and gallery_images
        #   image_galleries  = attributes['image_galleries'] || []
        #   group_by         = gallery_images.group_by { |gallery_image| gallery_image.image_gallery.id }
        #   @image_galleries = image_galleries.collect do |image_gallery|
        #     YoolkApi::ImageGallery.new(image_gallery, group_by[image_gallery['id']])
        #   end
        #   @image_galleries
        # end

        # def products
        #   return @products if @products

        #   products  = attributes['products'] || []
        #   @products = products.collect { |product| YoolkApi::Product.new(product) }
        #   @products
        # end

        # def logo
        #   return @logo if @logo

        #   logo  = attributes['logo']
        #   @logo = logo.present? ? YoolkApi::Logo.new(logo) : nil
        #   @logo
        # end

        define_method(sub_resource_name) do
          sub_resource_name    = sub_resource_name.to_s
          options[:collection] = true if sub_resource_name == sub_resource_name.pluralize
          sub_resource_klass   = klass_for_sub_resource(options)
          sub_resource         = instance_variable_get("@#{sub_resource_name}_sub_resource")
          return sub_resource if sub_resource

          if options[:contains]
            raise "Missing sub_resource :#{options[:contains]}." unless respond_to?(options[:contains])
            
            array        = attributes[sub_resource_name] || []
            group_by     = send(options[:contains]).group_by { |object| object.send(sub_resource_name.singularize).id }
            sub_resource = array.collect do |hash|
              sub_resource_klass.new(hash, group_by[hash['id']])
            end
          elsif options[:collection]
            array         = attributes[sub_resource_name] || []
            sub_resource  = array.map { |hash| sub_resource_klass.new(hash) }
          else
            hash          = attributes[sub_resource_name]
            sub_resource  = hash.present? ? sub_resource_klass.new(hash) : nil
          end
          instance_variable_set("@#{sub_resource_name}_sub_resource", sub_resource)
          sub_resource
        end
      end
    end
  end
end