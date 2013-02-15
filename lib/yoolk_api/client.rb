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
          JSON.parse(response.body)
        rescue JSON::ParserError => exception
          log(env, exception.message)
          nil
        end
      elsif response.timed_out?
        log(env, 'Request is timed out')
        nil
      elsif response.code == 0
        log(env, 'Curl error message')
        nil
      else
        log(env)
        nil
      end
    end
  end
end