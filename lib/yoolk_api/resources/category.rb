module YoolkApi
  class Category < Resource
    has_many :listings, class: 'Listing'
    has_many :sub_categories, class: 'Category'

    def parent
      return nil unless attributes.key?('parent_id')

      @parent ||= member YoolkApi.client.get(parent_api_path)
    end

    def parent_api_path
      self.class.api_path(identity) + '/parent'
    end
  end
end