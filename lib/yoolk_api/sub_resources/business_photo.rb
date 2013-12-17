module YoolkApi
  class BusinessPhoto < SubResource
    attr_reader :business_photos

    def initialize(attributes={}, business_photos=[])
      super(attributes)
      @business_photos = business_photos
    end
  end
end