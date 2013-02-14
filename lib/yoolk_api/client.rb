require 'typhoeus'
require 'json'

module YoolkApi
  class Client
    attr_reader :api_url, :domain_name, :version, :per_page, :fields

    def initialize(options={})
      @domain_name = options[:domain_name]
      @version     = options[:version] || 'v1'
      @api_url     = "http://#{domain_name}/api/#{version}"
      @fields      = options[:fields]  || []
      @per_page    = options[:per_page]
    end

    def get(path)
      response = ::Typhoeus.get("#{api_url}#{path}", followlocation: true)
      if response.success?
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError => exception
          # log
          nil
        end
      elsif response.timed_out?
        # log("got a time out")
        nil
      elsif response.code == 0
        # log(response.curl_error_message)
        nil
      else
        # log("HTTP request failed: " + response.code.to_s)
        nil
      end
    end
  end
end