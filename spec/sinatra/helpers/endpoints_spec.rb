RSpec.describe Sinatra::Helpers::Endpoints do
  describe '.get_root' do
    context 'with empty query strings' do
      it 'returns a 400 error' do
        get '/'
        expect(last_response).to be_bad_request
      end
    end

    it 'returns the match', :vcr do
      get('/', query: 'checkpoint charlie')
      expect(last_response.body).to eq({ lat: 52.5074434, lng: 13.3903913 }.to_json)
    end
  end
end
