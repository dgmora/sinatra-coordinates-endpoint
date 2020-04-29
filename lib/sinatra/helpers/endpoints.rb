module Sinatra
  module Helpers
    module Endpoints
      
      GEOCODING_URL = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze
      
      def get_root(query)
        verify_query!(query)
        geocode(query)
      end

      def get_raw(query)
        verify_query!(query)
        geocode_raw(query)
      end

      private

      # Geocodes the query parameter and returns the coordinates
      def geocode(query)
        response = geocode_raw(query)
        body = JSON.parse(response.body)
        verify_body!(body)
        result = body['results'].first.dig('geometry', 'location').to_json
      rescue RestClient::ExceptionWithResponse, RestClient::RequestTimeout => e
        handle_error(e)
      end

      # RestClient::ExceptionWithResponse is raised if the code is >400, and it has
      # the response attached. The timeout does not have a response so we'll handle it ourselves
      def handle_error(e)
        halt(500, 'There was a timeout') if e.is_a?(RestClient::RequestTimeout)
        google_status = JSON.parse(e.response.body)['status']
        halt(e.response.code, "There was an error calling google: :#{google_status}")
      end

      def verify_body!(body)
        return if body['results'].any?
        halt(404, 'There were no results')
      end

      # Geocodes query and directly returns the json that google returns
      def geocode_raw(query)
        params = { 'key' => ENV['GOOGLE_API_KEY'], 'address' => query }
        headers = { params: params, accept: 'json' }
        RestClient::Request.execute(method: :get, url: GEOCODING_URL, headers: headers, timeout: 5)
      end

      def verify_query!(query)
        halt(400, 'the query parameter cannot be empty') if query.empty?
      end
    end
  end
end
