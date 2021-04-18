RSpec.describe AdRoutes, type: :routes do
  describe 'GET /' do

    before do
      create_list(:ad, 3)
    end

    it 'returns a collection of ads' do
      get '/v1'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST /ads/v1' do
    let(:user_id) { 101 }
    let(:auth_token) { 'auth.token' }
    let(:coordinates) { { 'lat' => 123, 'lon' => 456 } }
    let(:auth_service) {
      instance_double('Authservice')
    }

    let(:geo_service) {
      instance_double('Geoservice')
    }

    before do
      allow(auth_service).to receive(:auth)
        .with(auth_token)
        .and_return(user_id)

      allow(AuthService::Client).to receive(:new).and_return(auth_service)

      header 'Authorization', "Bearer #{auth_token}"
    end

    before do
      allow(geo_service).to receive(:geocode)
        .and_return(coordinates)

      allow(GeoService::Client).to receive(:new).and_return(geo_service)
    end

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

        expect(last_response.status).to eq(422)

        expect(response_body['errors']).to include(
          {
            'detail' => 'Укажите город',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        }
      end

      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/v1', ad: ad_params }
          .to change { Ad.count }.from(0).to(1)

          expect(last_response.status).to eq(201)
        end

      it 'returns an ad' do
        post '/v1', ad: ad_params

        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id.to_s,
          'type' => 'ad'
        )

        expect(response_body['data']['attributes']).to a_hash_including(
          'lat' => 123.0,
          'lon' => 456.0
        )
      end
    end
  end
end
