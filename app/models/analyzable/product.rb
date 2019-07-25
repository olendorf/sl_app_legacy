# frozen_string_literal: true

module Analyzable
  # Provides a user a way of collection different manifestations of products
  # into one object. For instance multiple inventories and also marketplace products.
  class Product < ApplicationRecord
    # validates_uniqueness_of :product_name
    validates :product_name, uniqueness: { scope: :user_id }

    belongs_to :user
    has_many :aliases, class_name: 'Analyzable::ProductAlias', dependent: :destroy
  end
end
