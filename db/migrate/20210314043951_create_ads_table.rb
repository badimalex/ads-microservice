# frozen_string_literal: true

class CreateAdsTable < ::ActiveRecord::Migration[6.1]
  def change
    create_table :ads do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :city, null: false
      t.float :lat
      t.float :lon
      t.bigint :user_id, null: false, index: true
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end
  end
end
