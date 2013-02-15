module YoolkApi
  class Category < Resource
    has_many :listings, class: 'Listing'
  end
end