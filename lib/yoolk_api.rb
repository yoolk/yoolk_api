require 'yoolk_api/version'
require 'yoolk_api/error'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'
require 'active_support/concern'

module YoolkApi
  class << self
    def setup(options={})
      YoolkApi.client = YoolkApi::Client.new(options)
    end

    def client
      Thread.current[:yoolk_client]
    end

    def client=(new_client)
      Thread.current[:yoolk_client] = new_client
    end

    def with_client(options={}, &block)
      raise ArgumentError, "block required" if block.nil?

      begin
        old_client, YoolkApi.client = YoolkApi.client, YoolkApi::Client.new(options)
        
        block.call
      ensure
        YoolkApi.client = old_client
      end
    end
  end

  class StdoutLogger
    def initialize(debug)
      @debug = debug
    end

    def log(env, message="")
      begin
        puts "\n==> #{message}\n\n" if message
        puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n" if @debug
        yield if block_given?
      ensure
        puts "\n== (#{env[:status]}) ==> #{env[:body]}\n\n" if @debug
      end
    end
  end

  autoload :Client,             'yoolk_api/client'
  autoload :ResourceModel,      'yoolk_api/resource_model'
  autoload :HasManyAssociation, 'yoolk_api/has_many_association'
  autoload :Resource,           'yoolk_api/resource'

  autoload :ImageResource,      'yoolk_api/image_resource'
  autoload :Logo,               'yoolk_api/image_resources/logo'
  autoload :Artwork,            'yoolk_api/image_resources/artwork'
  autoload :CatalogItem,        'yoolk_api/image_resources/catalog_item'
  autoload :GalleryImage,       'yoolk_api/image_resources/gallery_image'
  autoload :Person,             'yoolk_api/image_resources/person'

  autoload :Portal,             'yoolk_api/resources/portal'
  autoload :Listing,            'yoolk_api/resources/listing'
  autoload :Location,           'yoolk_api/resources/location'
  autoload :Category,           'yoolk_api/resources/category'
  autoload :Account,            'yoolk_api/resources/account'
  autoload :ImageGallery,       'yoolk_api/resources/image_gallery'

  autoload :ResourceCollection, 'yoolk_api/resource_collection'
end
