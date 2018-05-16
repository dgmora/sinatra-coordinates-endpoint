ENV['RACK_ENV'] = 'test'
require 'coordinates_endpoint'
require 'rspec'
require 'rack/test'
require 'byebug'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.filter_run_when_matching :focus

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Rack::Test::Methods
end

VCR.configure do |vcr_config|
  vcr_config.cassette_library_dir = 'spec/vcr_cassettes'
  vcr_config.hook_into :webmock
  vcr_config.configure_rspec_metadata!
  vcr_config.filter_sensitive_data('<GOOGLE_API_KEY>') { ENV['GOOGLE_API_KEY'] }
  vcr_config.filter_sensitive_data('<SECRET_KEY>') { ENV['SECRET_KEY'] }
end

WebMock.disable_net_connect!(allow_localhost: true)

def app
  CoordinatesEndpoint
end

def query_with_auth(query = 'checkpoint charlie')
  get('/', secret_key: ENV['SECRET_KEY'], query: query)
end
