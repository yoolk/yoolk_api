module YoolkApi
  class Category < Resource::Base
    has_many :listings, class: 'Listing'
  end
end