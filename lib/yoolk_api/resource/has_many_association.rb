module YoolkApi::Resource::HasManyAssociation
  extend ActiveSupport::Concern

  included do
    def klass_for_association(options)
      klass_name = options[:class]
      raise "Missing class name of associated model. Provide with :class => 'MyClass'." unless klass_name.present?
      return self.class.klass_from_string(klass_name)
    end
  end

  module ClassMethods
    def has_many(association_name, options={})
      define_method(association_name) do
        klass = klass_for_association(options)
        instances = instance_variable_get("@#{association_name}_has_many_instances")

        if instances.blank?
          instances = if attributes.key?(association_name)
            self.class.collection attributes[association_name]
          else
            association_path = options[:api_path] || "/#{resource_name}/#{identity}/#{association_name}"
            self.class.collection YoolkApi.client.get(association_path)
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
  end
end