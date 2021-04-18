RSpec.describe GeoService::Client, type: :client do

  subject {
    described_class.new(connection: connection)
  }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:body) { {} }

  before do
    stubs.get('geocoder/search') {
      [status, headers, body.to_json]
    }
  end

  describe '#geocode (valid city)' do
    let(:coordinates) {{ lat:123, lon: 456 }}

    let(:body) {
      coordinates
    }

    it 'returns user_id' do


      expect(subject.geocode('valid.city')).to a_hash_including(
        'lat' => 123.0,
        'lon' => 456.0
      )
    end
  end

  describe '#geocode (invalid city)' do
    let(:status) { 403 }

    it 'returns a nil value' do
      expect(subject.geocode('invalid.city')).to be_nil
    end
  end
end
