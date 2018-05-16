RSpec.describe Sinatra::Extensions::Filters do
  describe '.require_authentication!' do
    it 'works if there is authentication' do
      expect_any_instance_of(CoordinatesEndpoint).to receive(:get_root)
      get('/', query: 'foo', secret_key: ENV['SECRET_KEY'])
    end

    it 'returns 403 if not authenticated' do
      get('/')
      expect(last_response).to be_forbidden
    end
  end
end
