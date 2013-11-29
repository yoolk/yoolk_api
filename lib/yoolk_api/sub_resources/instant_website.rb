module YoolkApi
  class InstantWebsite < SubResource
    autoload :Template,             'yoolk_api/sub_resources/instant_website/template'

    sub_resource :template, class_name: 'InstantWebsite::Template'
  end
end
