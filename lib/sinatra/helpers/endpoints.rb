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
        # Here we could implement anything custom to not block our app if google is down
        halt(e.response.code, ":see_no_evil: There was an error calling google: :#{google_status}")
      end

      def verify_body!(body)
        return if body['results'].any?
        halt(404, 'There were no results')
      end

      def geocode_raw(query)
        url = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze
        params = { 'key' => ENV['GOOGLE_API_KEY'], 'address' => query }
        # We can set any custom timeout we want, in case google is giving problems
        # not explicitely
        headers = { params: params, accept: 'json' }
        RestClient::Request.execute(method: :get, url: url, headers: headers, timeout: 5)
      end

      def verify_query!(query)
        halt(400, 'the query parameter cannot be empty') if query.empty?
      end
    end
  end
end
