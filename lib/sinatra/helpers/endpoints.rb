module Sinatra
  module Helpers
    module Endpoints
      def get_root(query)
        verify_query!(query)
        geocode(query)
      end

      def geocode(query)
        url = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze
        params = { 'key' => ENV['GOOGLE_API_KEY'], 'address' => query }
        body = RestClient.get(url, params: params, accept: 'json').body
        JSON.parse(body)['results'].first.dig('geometry', 'location').to_json
      end

      def verify_query!(query)
        halt(400, 'the query parameter cannot be empty') if query.empty?
      end
    end
  end
end
