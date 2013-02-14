module YoolkApi
  module Resource
    class Base
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
        def find(identity)
          member YoolkApi.client.get("/#{resource_name}/#{identity}")
        end

        def resource_name
          name.split('::').last.downcase.pluralize
        end

        def member(response)
          new(response['data'])
        end

        def collection(response)
          paging = response['paging']
          result = OpenStruct.new(
            all: response['data'],
            total_entries: paging['total_entries'],
            total_pages: paging['total_pages'],
            per_page: paging['per_page'],
            current_page: paging['current_page']
          )
          result.all.map! { |item| new(item) }
          result
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
end