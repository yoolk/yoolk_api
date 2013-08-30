require 'hashie/mash'

module YoolkApi
  class Resource
    autoload :Collection,         'yoolk_api/resource/collection'
    autoload :ImageMethods,       'yoolk_api/resource/image_methods'
    autoload :HasManyMethods,     'yoolk_api/resource/has_many_methods'
    autoload :SubResourceMethods, 'yoolk_api/resource/sub_resource_methods'

    include HasManyMethods
    include SubResourceMethods

    attr_reader :attributes
    delegate    :resource_name, :member,
                to: 'self.class'

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

      def klass_from_string(klass_name)
        klass = klass_name.constantize rescue nil
        klass = "YoolkApi::#{klass_name}".constantize unless klass.respond_to?(:ancestors) && klass.ancestors.include?(YoolkApi)
        klass
      end
    end

    def initialize(attributes={})
      @attributes = Hashie::Mash.new(attributes)
    end

    def identity
      alias_id || id
    end

    def respond_to?(method, include_private=false)
      return true if attributes.respond_to?(method.to_s)
      super
    end

    private

      def method_missing(method, *args, &block)
        if respond_to?(method)
          attributes.send(method, *args, &block)
        else
          super
        end
      end

  end
end
