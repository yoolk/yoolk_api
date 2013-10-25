module YoolkApi
  class Food::Category < SubResource
    attr_reader :foods

    def initialize(attributes={}, foods=[])
      super(attributes)
      @foods = foods
    end
  end
end