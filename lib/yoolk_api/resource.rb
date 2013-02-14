require 'hashie/mash'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

module YoolkApi
  class Resource
    attr_reader :attributes

    def initialize(attributes)
      @attributes = Hashie::Mash.new(attributes)
    end

    def self.find(identity)
      result = client.get("/#{resource_name}/#{identity}")
      new(result['data']) if result
    end

    def self.resource_name
      self.name.split('::').last.downcase.pluralize
    end

    private
    def method_missing(*args, &block)
      @attributes.send(*args, &block)
    end
  end
end