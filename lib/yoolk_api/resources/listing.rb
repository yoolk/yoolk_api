module YoolkApi
  class Listing < Resource
    has_many :categories, class: 'Category'
  end
end