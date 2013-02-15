module YoolkApi
  class Location < Resource
    has_many :listings, class: 'Listing'
  end
end