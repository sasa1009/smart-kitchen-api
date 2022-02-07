class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  has_many :procedures, dependent: :destroy
end
