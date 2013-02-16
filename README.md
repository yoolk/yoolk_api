# YoolkApi

This is the official Ruby client for accessing the Yoolk Portal REST API. It also provides idiomatic Ruby methods for accessing data from yoolk portals. This client library is designed to be minimal and easily integrable into your projects.

## Installation

Add this line to your application's Gemfile:

    gem 'yoolk_api', :git => 'git://github.com/yoolk/yoolk_api.git'

And then execute:

    $ bundle

## Configuration

The main way of using the YoolkApi library is via a singleton client, which you set up like this:

    YoolkApi.setup(domain_name: 'panpages.my')

This initializes a `YoolkApi::Client` object and assigns it to a thread-local, which is used by all methods in this library.

## Basic Usage

The Yoolk API is based on REST requests passing JSON back and forth, but we have tried to make the use of this client an experience more similar to using ActiveRecord from Rails.

    # Fetch the current portal
    portal = YoolkApi::Portal.current

    # Fetch the current portal, select 'id' and 'domain_name' only
    portal = YoolkApi::Portal.current(fields: 'id,domain_name')

    # Fetch category/location/listing by id or alias_id
    category = YoolkApi::Category.find('kh70')
    location = YoolkApi::Location.find('kh2')
    listing = YoolkApi::Listing.find('kh7364', fields: 'id,name')

    # Relation
    portal.listings         # Fetch listings under this portal
    category.sub_categories # Fetch its sub_categories
    sub_category.listings   # Fetch listings under this category
    location.listings       # Fetch listings under this location

    # Chaining
    portal.listings
    => /api/v1/listings

    listings = portal.listings.per_page(5).page(2).fields('id,name').q('phone shop')
    => /api/v1/listings?per_page=5&page=2&fields=id,name&q=phone+shop

    # Paging
    listings.total_entries
    listings.total_pages
    listings.per_page
    listings.current_page
    listings.next_page
    listings.previous_page
    listings.offset
    listings.page_offset

## Error Handling

All unsuccessful responses returned by the API (everything that has a 4xx or 5xx HTTP status code) will throw exceptions. All exceptions inherit from YoolkApi::Error and have three additional properties which give you more information about the error:

begin
  YoolkApi::Listing.find('not_found')
rescue YoolkApi::NotFoundError => exc
  puts exc.response_body      # parsed JSON response from the API
  puts exc.response_status    # status code of the response
  puts exc.url                # uri of the API request

  # you normally want this one, a human readable error description
  puts exc.response_body['error']
end

## Authors

* [Chamnap Chhorn](https://github.com/chamnap)
* [Vorleak Chy](https://github.com/vorleakchy)
