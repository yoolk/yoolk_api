module YoolkApi
  class Portal < Resource
    delegate :code,
             prefix: true, to: :currency, allow_nil: true
    has_many :locations,  class: 'Location', api_path: '/locations'
    has_many :categories, class: 'Category', api_path: '/categories'
    has_many :listings,   class: 'Listing',  api_path: '/listings'

    def identity
      domain_name || id
    end

    class << self
      undef_method :find

      def current
        result = YoolkApi.client.get("/")
        new(result['data']) if result
      end
    end
  end
end