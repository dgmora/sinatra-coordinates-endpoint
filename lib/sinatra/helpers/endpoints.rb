module Sinatra
  module Helpers
    module Endpoints
      def get_root(query)
        verify_query!(query)
      end

      def verify_query!(query)
        halt(400, 'the query parameter cannot be empty') if query.empty?
      end
    end
  end
end
