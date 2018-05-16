RSpec.describe Sinatra::Helpers::Endpoints do
  context 'with errors like' do
    describe 'empty query strings' do
      it 'returns a 400 error' do
        get '/'
        expect(last_response).to be_bad_request
      end
    end

    describe 'missing authentication' do
    end
  end

  context 'incorrect endpoint' do
  end
end
