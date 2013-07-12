module YoolkApi
  class Location < Resource
    has_many :listings, class_name: 'Listing'
  end
end