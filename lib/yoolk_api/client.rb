require 'typhoeus'
require 'oj'

module YoolkApi
  class Client
    attr_reader :api_url, :domain_name, :version

    def initialize(options={})
      @domain_name = options[:domain_name]
      @version     = options[:version] || 'v1'
      @logger      = options[:logger]  || StdoutLogger.new(options[:debug])
      @api_url     = "http://#{domain_name}/api/#{version}"
    end

    def log(env, message, &block)
      @logger.log(env, message, &block)
    end

    def get(path)
      response = ::Typhoeus.get("#{api_url}#{path}")
      env = {
        method: response.request.options[:method],
        url: response.request.url,
        status: response.code,
        body: response.body
      }
      
      if response.success?
        begin
          Oj.load(response.body)
        rescue Oj::ParseError => exception
          raise JsonError.new(env[:body], env[:status], env[:url])
        end
      elsif response.timed_out?
        raise NetworkError.new(env[:body], env[:status], env[:url])
      elsif response.code == 0
        raise NetworkError.new(env[:body], env[:status], env[:url])
      elsif response.code == 400
        raise BadRequestError.new(env[:body], env[:status], env[:url])
      elsif response.code == 401
        raise AuthorizationError.new(env[:body], env[:status], env[:url])
      elsif response.code == 404
        raise NotFoundError.new(env[:body], env[:status], env[:url])
      elsif response.code == 502 or response.code == 503
        raise UnavailableError.new(env[:body], env[:status], env[:url])
      elsif response.code == 500
        raise ServerError.new(env[:body], env[:status], env[:url])
      else
        raise ServerError.new(env[:body], env[:status], env[:url])
      end
    end
  end
end