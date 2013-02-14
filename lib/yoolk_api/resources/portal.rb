module YoolkApi
  class Portal < Resource
    delegate :code,
             prefix: true, to: :currency, allow_nil: true

    class << self
      undef_method :find

      def current
        result = YoolkApi.client.get("/")
        new(result['data']) if result
      end
    end
  end
end