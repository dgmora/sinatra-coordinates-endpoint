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

    it 'returns the first value if there are multiple values', :vcr do
      # Mainzerstr. gets multiple results back.
      get('/', query: 'mainzerstr')
      expect(last_response.body).to eq({ lat: 44.916855, lng: -93.0730131 }.to_json)
    end

    it 'returns 404 if the place does not exist', :vcr do
      get('/', query: 'Gazorpazorp')
      expect(last_response).to be_not_found
    end
  end
end
