RSpec.describe Sinatra::Extensions::Filters do
  describe '.require_authentication!' do
    it 'works if there is authentication' do
      get('/', query: 'foo')
      expect(last_response).to be_ok
    end

    it 'returns 403 if not authenticated' do
      get('/')
      expect(last_response).to be_forbidden
    end
  end
end
