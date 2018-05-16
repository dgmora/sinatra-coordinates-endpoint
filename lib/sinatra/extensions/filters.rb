module Sinatra
  module Extensions
    module Filters
      def require_authentication!
        before do
          # halt(403, '👎 boo, bad authentication!')
        end
      end
    end
  end
end
