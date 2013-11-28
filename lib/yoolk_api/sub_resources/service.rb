module YoolkApi
  class Service < SubResource
    autoload :Photo, 'yoolk_api/sub_resources/service/photo'

    sub_resource :photos, class_name: 'Service::Photo'
  end
end