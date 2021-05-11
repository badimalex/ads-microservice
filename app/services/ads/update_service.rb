module Ads
  class UpdateService
    prepend BasicService

    param :id
    param :data

    option :ad, default: proc { Ad.first(id: @id) }

    def call
      return fail!('Объявление не найдено') if @ad.blank?

      @ad.update_fields(@data, %i[lat lon])

      Application.logger.info(
        'updated coordinates',
        ad_id: @ad.id,
        lat: data[:lat],
        lon: data[:lon],
      )
    end
  end
end
