module YoolkApi
  class Product::Category < Resource
    attr_reader :products
    
    def initialize(attributes={}, products=[])
      super(attributes)
      @products = products
    end

    class << self
      undef_method :find
    end
  end
end