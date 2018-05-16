#!/usr/local/bin/ruby

require 'dotenv/load'
require 'sinatra/base'
require 'rest-client'

require_relative 'sinatra/helpers/endpoints'
require_relative 'sinatra/extensions/filters'

class CoordinatesEndpoint < Sinatra::Base
  helpers Sinatra::Helpers::Endpoints
  register Sinatra::Extensions::Filters

  require_authentication!

  get '/' do
    content_type :json
    get_root(params.fetch('query', ''))
  end
end
