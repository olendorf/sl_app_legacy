class Rezzable::Terminal < ApplicationRecord
  acts_as :rezzable, class_name: 'Rezzable::WebObject'
end
