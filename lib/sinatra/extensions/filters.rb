module Sinatra
  module Extensions
    module Filters
      def require_authentication!
        before do
          true
        end
      end
    end
  end
end
