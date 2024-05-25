class RamenReview < ApplicationRecord
  belongs_to :restaurant
  has_many :review_images, dependent: :destroy
  after_save :update_restaurant_average_score

  private

  def update_restaurant_average_score
    restaurant.update_average_score
  end
end
