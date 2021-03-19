# frozen_string_literal: true

require 'fast_jsonapi'

class AdSerializer
  include ::FastJsonapi::ObjectSerializer

  attributes :title,
             :description,
             :city,
             :lat,
             :lon
end
