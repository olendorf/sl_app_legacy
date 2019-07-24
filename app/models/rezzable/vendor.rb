class Rezzable::Vendor < ApplicationRecord
  acts_as :web_object, class_name: 'Rezzable::WebObject'
end
