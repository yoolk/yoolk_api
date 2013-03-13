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

    delegate :resource_name, :member,
             to: 'self.class'

    def initialize(attributes)
      @attributes = Hashie::Mash.new(attributes)
    end

    def identity
      alias_id || id
    end

    class << self
      def find(identity, query={})
        raise YoolkApi::NotFoundError.new(nil, 404, api_path) if identity.blank?

        member YoolkApi.client.get(api_path(identity, query))
      end

      def resource_name
        name.split('::').last.downcase.pluralize
      end

      def member(response)
        new(response['data'])
      end

      def api_path(identity='', query={})
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