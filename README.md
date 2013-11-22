# YoolkApi [![Build Status](https://travis-ci.org/yoolk/yoolk_api.png?branch=master)](https://travis-ci.org/yoolk/yoolk_api) [![Code Climate](https://codeclimate.com/repos/527f0090c7f3a35566082bf4/badges/c19085110192a2f43e91/gpa.png)](https://codeclimate.com/repos/527f0090c7f3a35566082bf4/feed) [![Dependency Status](https://gemnasium.com/yoolk/yoolk_api.png)](https://gemnasium.com/yoolk/yoolk_api) [![Coverage Status](https://coveralls.io/repos/yoolk/yoolk_api/badge.png?branch=master)](https://coveralls.io/r/yoolk/yoolk_api?branch=master)

This is the official Ruby client for accessing the Yoolk Portal REST API. It also provides idiomatic Ruby methods for accessing data from yoolk portals. This client library is designed to be minimal and easily integrable into your projects.

## Installation

This gem depends on [typhoeus](https://github.com/typhoeus/typhoeus) which uses `libcurl` library. On Ubuntu 12.04, you should install:

    $ sudo apt-get install -y curl libcurl4-gnutls-dev

Add this line to your application's Gemfile:

    gem 'yoolk_api', github: 'yoolk/yoolk_api', tag: 'v0.1.0'

And then execute:

    $ bundle

## Configuration

The main way of using the YoolkApi library is via a singleton client, which you set up like this:

    YoolkApi.setup(domain_name: 'panpages.my')

This initializes a `YoolkApi::Client` object and assigns it to a thread-local, which is used by all methods in this library.

## API Summary

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
    portal.categories       # Fetch categories under this portal
    portal.locations        # Fetch locations under this portal

    category.sub_categories # Fetch its sub_categories
    sub_category.listings   # Fetch listings under this category
    sub_category.parent     # Fetch parent category

    location.listings       # Fetch listings under this location

    # Return all images size
    listing.logo.images

    # Return only original images, applied to any resources which contains images array.
    listing.logo.images(:original)

    # Image_galleries and gallery_images
    listing.image_galleries[0].name
    listing.image_galleries[0].gallery_images

    # Products
    listing.products[0].name
    listing.products[0].photos[0].images(:small)
    listing.product_categories[0].products
    listing.product_brands[0].products

    # Foods
    listing.foods[0].name
    listing.foods[0].photos[0].images(:small)
    listing.food_categories[0].foods
    listing.menu_sources[0].images(:small)

    # Get information about current account
    current_account = YoolkApi::Account.me
    current_account.yoolk_admin?
    current_account.has_portal_role?('Portal Admin')

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
      puts exc.response_body['message']
    end

## Rails

Because `YoolkApi::Client` is the current thread variable, it's advisable to set to `nil` after processing controller action. This can be easily achievable by using `around_filter` inside `application_controller.rb`.

    class ApplicationController < ActionController::Base
      around_filter :setup_yoolk_api

      protected
      def setup_yoolk_api(&block)
        YoolkApi.with_client({domain_name: params[:domain_name]}, &block)
      end
    end

While the models can be used directly from this gem, we encourage everyone using YoolkApi in a Rails project to add models that extend the standard models:

    class Listing < YoolkApi::Listing # Inherits from the Listing model in the YoolkApi gem

      # Your custom methods, e.g.:
      def code
        alias_id.to_s.gsub(/\D/, '')
      end
    end

It's such a good idea to catch all exceptions that this gem will raise. Please check out `error.rb` to see all exceptions. In your `application_controller.rb`, use `rescue_from` to catch these exceptions:

    class ApplicationController < ActionController::Base
      rescue_from YoolkApi::NotFoundError,
                  YoolkApi::JsonError,
                  YoolkApi::NetworkError,
                  YoolkApi::AuthorizationError,
                  YoolkApi::BadRequestError,
                  YoolkApi::ServerError,
                  YoolkApi::UnavailableError,
                  with: :render_api_error

      protected
      def render_api_error
        render 'public/api_error', layout: false
      end
    end

## Authors

* [Chamnap Chhorn](https://github.com/chamnap)
* [Vorleak Chy](https://github.com/vorleakchy)
