RSpec.describe Sinatra::Helpers::Endpoints do
  describe '.get_root' do
    context 'with errors' do
      it 'returns a 400 if there is no query' do
        query_with_auth('')
        expect(last_response).to be_bad_request
      end

      it 'returns a 500 custom error if google is down' do
        stub_request(:any, /maps.googleapis.com/)
          .to_return(status: 500, body: '{"status" : "Internal Server Error"}')
        query_with_auth
        expect(last_response).to be_server_error
        expect(last_response.body).to start_with ':see_no_evil:'
      end
    end

    it 'returns the match', :vcr do
      query_with_auth
      expect(last_response.body).to eq({ lat: 52.5074434, lng: 13.3903913 }.to_json)
    end

    it 'returns the first value if there are multiple values', :vcr do
      # Mainzerstr. gets multiple results back.
      query_with_auth('mainzerstr')
      expect(last_response.body).to eq({ lat: 44.916855, lng: -93.0730131 }.to_json)
    end

    it 'returns 404 if the place does not exist', :vcr do
      query_with_auth('Gazorpazorp')
      expect(last_response).to be_not_found
    end
  end
end
