require 'hashie/mash'

module YoolkApi
  class Resource
    autoload :Model,      'yoolk_api/resource/model'
    autoload :Image,      'yoolk_api/resource/image'
    autoload :HasMany,    'yoolk_api/resource/has_many'
    autoload :Collection, 'yoolk_api/resource/collection'

    include Model
    include HasMany

    delegate :resource_name, :member,
             to: 'self.class'

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
  end
end