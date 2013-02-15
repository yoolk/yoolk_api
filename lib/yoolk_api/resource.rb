require 'hashie/mash'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'
require 'active_support/concern'

module YoolkApi
  class Resource
    include HasManyAssociation
    attr_reader :attributes

    def initialize(attributes)
      @attributes = Hashie::Mash.new(attributes)
    end

    def identity
      alias_id || id
    end

    def resource_name
      self.class.resource_name
    end

    class << self
      def find(identity, query={})
        member YoolkApi.client.get(api_path(identity, query))
      end

      def resource_name
        name.split('::').last.downcase.pluralize
      end

      def member(response)
        new(response['data'])
      end

      def api_path(identity, query={})
        "/#{resource_name}/#{identity}?#{query.to_query}".gsub(/\?$/, '')
      end
    end

    private
    def method_missing(method, *args, &block)
      if @attributes.key?(method)
        @attributes.send(method, *args, &block)
      else
        super
      end
    end
  end
end