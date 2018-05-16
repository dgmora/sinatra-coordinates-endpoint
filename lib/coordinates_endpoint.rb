#!/usr/local/bin/ruby

require 'sinatra/base'
require 'sinatra/helpers/endpoints'
require 'sinatra/extensions/filters'

class CoordinatesEndpoint < Sinatra::Base
  helpers Sinatra::Helpers::Endpoints
  register Sinatra::Extensions::Filters

  require_authentication!

  get '/' do
    get_root(params.fetch('query', ''))
  end
end
