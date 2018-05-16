module Sinatra
  module Extensions
    module Filters
      def require_authentication!
        before do
          return if params['secret_key'] == ENV['SECRET_KEY']
          halt(403, '👎 boo, bad authentication!')
        end
      end
    end
  end
end
