module YoolkApi
  class Account < Resource

    class << self
      undef_method :find

      def me(query={})
        begin
          response = YoolkApi.client.get(api_path(query))
        rescue JsonError, NetworkError, BadRequestError => exception
          raise NotFoundError.new(exception.response_body, exception.response_status, exception.url)
        end
        member response
      end

      def api_path(query={})
        "/me?#{query.to_query}".gsub(/\?$/, '')
      end
    end
  end
end