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

  class StdoutLogger
    def initialize(debug)
      @debug = debug
    end

    def log(message, env)
      begin
        puts "\n==> #{message}\n\n"
        puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n" if @debug
        yield
      ensure
        puts "\n== (#{env[:status]}) ==> #{env[:body]}\n\n" if @debug
      end
    end
  end

  autoload :Client,             'yoolk_api/client'
  autoload :Resource,           'yoolk_api/resource'
  autoload :HasManyAssociation, 'yoolk_api/has_many_association'

  autoload :Portal,             'yoolk_api/resources/portal'
  autoload :Listing,            'yoolk_api/resources/listing'
  autoload :Location,           'yoolk_api/resources/location'
  autoload :Category,           'yoolk_api/resources/category'

  autoload :ResourceCollection, 'yoolk_api/resource_collection'
end
