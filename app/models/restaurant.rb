class Restaurant < ApplicationRecord
  has_many :ramen_reviews, dependent: :destroy
  geocoded_by :address
  after_validation :geocode
end
