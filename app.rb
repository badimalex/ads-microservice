# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'kaminari'
require './environments'

require './serializers/ad_serializer'
require './helpers/pagination_links'
require './application_record'

helpers do
  include ::PaginationLinks
end

class Ad < ApplicationRecord
  belongs_to :user

  validates :title, :description, :city, presence: true
end

get '/' do
  content_type :json

  ads = ::Ad.order(updated_at: :desc).page(params[:page])
  serializer = ::AdSerializer.new(ads, links: pagination_links(ads))

  serializer.serialized_json
end
