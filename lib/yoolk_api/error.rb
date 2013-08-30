module YoolkApi
  class Error < StandardError
    attr_reader :response_body, :response_status, :url

    def initialize(response_body, response_status, url)
      @response_body, @response_status, @url = response_body, response_status, url

      super(response_body.inspect)
    end
  end

  class JsonError < Error; end
  class NetworkError < Error; end
  class AuthorizationError < Error; end
  class BadRequestError < Error; end
  class ServerError < Error; end
  class NotFoundError < Error; end
  class UnavailableError < Error; end
end