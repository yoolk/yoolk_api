module YoolkApi
  class Location < Resource::Base
    has_many :listings, class: 'Listing'
  end
end