require 'yoolk_api/version'
require 'yoolk_api/error'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'
require 'active_support/concern'

module YoolkApi

  autoload :Client,             'yoolk_api/client'
  autoload :Resource,           'yoolk_api/resource'
  autoload :SubResource,        'yoolk_api/sub_resource'
  
  # resources
  autoload :Portal,             'yoolk_api/resources/portal'
  autoload :Listing,            'yoolk_api/resources/listing'
  autoload :Location,           'yoolk_api/resources/location'
  autoload :Category,           'yoolk_api/resources/category'

  # sub_resources
  autoload :Account,            'yoolk_api/sub_resources/account'
  autoload :ImageGallery,       'yoolk_api/sub_resources/image_gallery'
  autoload :Logo,               'yoolk_api/sub_resources/logo'
  autoload :Artwork,            'yoolk_api/sub_resources/artwork'
  autoload :CatalogItem,        'yoolk_api/sub_resources/catalog_item'
  autoload :GalleryImage,       'yoolk_api/sub_resources/gallery_image'
  autoload :Person,             'yoolk_api/sub_resources/person'
  autoload :Product,            'yoolk_api/sub_resources/product'
  
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
end