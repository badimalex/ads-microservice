require 'sinatra/extension'

module Geocoder
  def coordinates
    @coordinates ||= geo_service.geocode(params.dig('ad', 'city'))
  end

  private

  def geo_service
    @geo_service ||= GeoService::Client.new
  end
end
