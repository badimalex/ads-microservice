module GeoService
  module Api

    def geocode(city)
      response = connection.get('geocoder/search', city: city)

      response.body if response.success?
    end

  end
end
