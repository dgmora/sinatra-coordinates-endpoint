module Sinatra
  module Helpers
    module Endpoints
      def get_root(query)
        verify_query!(query)
        geocode(query)
      end

      def get_raw(query)
        verify_query!(query)
        geocode_raw(query)
      end

      private

      def geocode(query)
        body = JSON.parse(geocode_raw(query))
        verify_body!(body)
        result = body['results'].first
        result.dig('geometry', 'location').to_json
      end

      def verify_body!(body)
        halt(404, "Google status code: #{body['status']}") if body['results'].empty?
      end

      def geocode_raw(query)
        url = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze
        params = { 'key' => ENV['GOOGLE_API_KEY'], 'address' => query }
        RestClient.get(url, params: params, accept: 'json').body
      end

      def verify_query!(query)
        halt(400, 'the query parameter cannot be empty') if query.empty?
      end
    end
  end
end
