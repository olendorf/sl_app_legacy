class Rezzable::WebObject < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
