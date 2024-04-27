class RamenReview < ApplicationRecord
  belongs_to :restaurant
  has_many :review_images, dependent: :destroy
end
