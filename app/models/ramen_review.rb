class RamenReview < ApplicationRecord
  belongs_to :restaurant
  has_many :review_images, -> { order(position: :asc) }, dependent: :destroy
  has_rich_text :content
  after_save :update_restaurant_average_score
  accepts_nested_attributes_for :review_images

  private

  def update_restaurant_average_score
    restaurant.update_average_score
  end

  def self.ransackable_attributes(auth_object = nil)
    ['soup']
  end

  def self.ransackable_associations(auth_object = nil)
    ['restaurant']
  end
end
