module YoolkApi
  class Portal < Resource
    delegate :code,
             prefix: true, to: :currency, allow_nil: true
    has_many :locations,  class_name: 'Location', api_path: '/locations'
    has_many :categories, class_name: 'Category', api_path: '/categories'
    has_many :listings,   class_name: 'Listing',  api_path: '/listings'

    def identity
      domain_name || id
    end

    class << self
      undef_method :find

      def current(query={})
        begin
          response = YoolkApi.client.get(api_path(query))
        rescue JsonError, NetworkError, BadRequestError => exception
          raise NotFoundError.new("YoolkApi::Error, Invalid api_url: #{YoolkApi.client.api_url}", 404, exception.url)
        end
        member response
      end

      def api_path(query={})
        "/?#{query.to_query}".gsub(/\?$/, '')
      end
    end
  end
end
