module YoolkApi
  class Category < Resource
    has_many :listings, class_name: 'Listing'
    has_many :sub_categories, class_name: 'Category'

    def parent
      return nil unless attributes.key?('parent_id')
      return nil if parent_id.blank?

      @parent ||= member YoolkApi.client.get(parent_api_path)
    end

    def parent_api_path
      self.class.api_path(identity) + '/parent'
    end
  end
end