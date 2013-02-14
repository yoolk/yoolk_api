module YoolkApi
  class Portal < Resource
    class << self
      undef_method :find
      
      def current
        result = YoolkApi.client.get("/")
        new(result['data']) if result
      end

    end
  end
end