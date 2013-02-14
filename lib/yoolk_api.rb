require "yoolk_api/version"

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

    def with_client
      old_client = YoolkApi.client.try(:dup)
      yield
    ensure
      YoolkApi.client = old_client
    end
  end

  autoload :Client,   'yoolk_api/client'
  autoload :Resource, 'yoolk_api/resource'
  autoload :Portal,   'yoolk_api/resources/portal'
  autoload :Portal,   'yoolk_api/resources/listing'
  autoload :Portal,   'yoolk_api/resources/location'
  autoload :Portal,   'yoolk_api/resources/category'
end
