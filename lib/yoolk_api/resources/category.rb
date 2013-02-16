module YoolkApi
  class Category < Resource
    has_many :listings, class: 'Listing'
    has_many :sub_categories, class: 'Category'
  end
end