require 'pry'
require 'yoolk_api'
require 'vcr'

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    YoolkApi.setup(
      domain_name: 'yellowpages-cambodia.dev:3000'
    )
  end
end