module YoolkApi
  class Portal < Resource::Base
    delegate :code,
             prefix: true, to: :currency, allow_nil: true
    has_many :locations,  class: 'Location'
    has_many :categories, class: 'Category'
    has_many :listings,   class: 'Listing'

    class << self
      undef_method :find

      def current
        result = YoolkApi.client.get("/")
        new(result['data']) if result
      end
    end
  end
end