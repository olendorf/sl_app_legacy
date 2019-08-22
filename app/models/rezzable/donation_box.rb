class Rezzable::DonationBox < ApplicationRecord
  acts_as :web_object, class_name: 'Rezzable::WebObject'

  has_many :splits, as: :splittable,
                    class_name: 'Analyzable::Split',
                    dependent: :destroy
                    
  enum reset_period: {
    manual: 0,
    weekly: 604800,
    monthly: 2419200
  }
end
