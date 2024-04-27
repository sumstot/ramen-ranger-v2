class ReviewImage < ApplicationRecord
  belongs_to :ramen_review
  has_one_attached :image
end
