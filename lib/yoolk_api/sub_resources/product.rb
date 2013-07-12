module YoolkApi
  class Product < SubResource
    autoload :Photo,            'yoolk_api/sub_resources/product/photo'
    autoload :Category,         'yoolk_api/sub_resources/product/category'
    autoload :Brand,            'yoolk_api/sub_resources/product/brand'

    sub_resource :photos, class_name: 'Product::Photo'

    def product_category
      category
    end

    def product_brand
      brand
    end
  end
end