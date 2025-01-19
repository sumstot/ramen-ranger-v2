class ReviewImage < ApplicationRecord
  belongs_to :ramen_review
  has_one_attached :image
  acts_as_list scope: :ramen_review, top_of_list: 0
end
