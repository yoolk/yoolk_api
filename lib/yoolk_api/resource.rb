require 'hashie/mash'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

module YoolkApi
  class Resource
    attr_reader :attributes

    def initialize(attributes)
      @attributes = Hashie::Mash.new(attributes)
    end

    class << self
      def find(identity)
        member YoolkApi.client.get("/#{resource_name}/#{identity}")
      end

      def has_many(association_name, options={})
        define_method(association_name) do
          klass = klass_for_association(options)
          instances = instance_variable_get("@#{association_name}_has_many_instances")

          if instances.blank?
            instances = if attributes.key?(association_name)
              self.class.collection attributes[association_name]
            else
              self.class.collection YoolkApi.client.get("/#{resource_name}/#{identity}/#{association_name}")
            end
            instance_variable_set("@#{association_name}_has_many_instances", instances)
          end
          instances
        end

        define_method("#{association_name}?") do
          send(association_name).length > 0
        end
      end

      def klass_from_string(klass_name)
        klass = klass_name.constantize rescue nil
        klass = "YoolkApi::#{klass_name}".constantize unless klass.respond_to?(:ancestors) && klass.ancestors.include?(YoolkApi::Resource)
        klass
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
    def klass_for_association(options)
      klass_name = options[:class]
      raise "Missing class name of associated model. Provide with :class => 'MyClass'." unless klass_name.present?
      return self.class.klass_from_string(klass_name)
    end

    def method_missing(*args, &block)
      @attributes.send(*args, &block)
    end
  end
end