# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'kaminari'
require './environments'

require './helpers/pagination_links'

require './serializers/ad_serializer'

require './application_record'

helpers do
  include ::PaginationLinks
end

class Ad < ApplicationRecord
  belongs_to :user

  validates :title, :description, :city, :user, presence: true
end

class User < ApplicationRecord
  NAME_FORMAT = /\A\w+\z/

  has_many :ads

  validates :name, :email, presence: true
  validates :name, format: { with: NAME_FORMAT }

  has_secure_password
end

get '/' do
  content_type :json

  ads = ::Ad.order(updated_at: :desc).page(params[:page])
  serializer = ::AdSerializer.new(ads, links: pagination_links(ads))

  serializer.serialized_json
end

post '/ads' do
  ad_params = JSON.parse(request.body.read, symbolize_names: true)

  ad_object = Ad.new(ad_params[:ad])

  if ad_object.save
    status 201
    ad_object.to_json
  else
    status 422
    ad_object.errors.to_json
  end
end
