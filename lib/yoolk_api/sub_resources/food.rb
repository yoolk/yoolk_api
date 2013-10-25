module YoolkApi
  class Food < SubResource
    autoload :Photo,            'yoolk_api/sub_resources/food/photo'
    autoload :Category,         'yoolk_api/sub_resources/food/category'
    autoload :MenuSource,       'yoolk_api/sub_resources/food/menu_source'

    sub_resource :photos, class_name: 'Food::Photo'
    sub_resource :menu_sources, class_name: 'Food::MenuSource'

    def food_category
      category
    end
  end
end