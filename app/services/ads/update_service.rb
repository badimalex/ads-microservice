module Ads
  class UpdateService
    prepend BasicService

    param :id
    param :data

    option :ad, default: proc { Ad.first(id: @id) }

    def call
      return fail!('Объявление не найдено') if @ad.blank?

      @ad.update_fields(@data, %i[lat lon])
    end
  end
end
