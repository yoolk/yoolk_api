module YoolkApi
  module ResourceModel
    extend ActiveSupport::Concern

    included do
      attr_reader :attributes

      def initialize(attributes={})
        @attributes = Hashie::Mash.new(attributes)
      end
      
      private
      def method_missing(method, *args, &block)
        if attributes.key?(method)
          attributes.send(method, *args, &block)
        else
          super
        end
      end
    end
  end
end