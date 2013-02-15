require 'typhoeus'
require 'json'

module YoolkApi
  class Client
    attr_reader :api_url, :domain_name, :version

    def initialize(options={})
      @domain_name = options[:domain_name]
      @version     = options[:version] || 'v1'
      @api_url     = "http://#{domain_name}/api/#{version}"
      @logger      = options[:logger] || StdoutLogger.new(options[:debug])
    end

    def log(env, &block)
      @logger.log(env, &block)
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
          JSON.parse(response.body)
        rescue JSON::ParserError => exception
          log(exception.message, env)
          nil
        end
      elsif response.timed_out?
        log('Request is time out', env)
        nil
      elsif response.code == 0
        log(response.curl_error_message, env)
        nil
      else
        log(nil, env)
        nil
      end
    end
  end
end