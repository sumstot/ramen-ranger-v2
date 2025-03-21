class RamenReview < ApplicationRecord
  belongs_to :restaurant
  has_many :review_images, -> { order(position: :asc) }, dependent: :destroy
  has_rich_text :content
  after_save :update_restaurant_average_score
  accepts_nested_attributes_for :review_images, allow_destroy: true

  SOUP_TYPES = %w[Shoyu Shio Tonkotsu Niboshi Tantanmen Iekei Mazesoba Tsukemen Reimen Jiro].freeze
  POSSIBLE_SCORES = (0.0..5.0).step(0.1).map { |n| n.round(1) }.freeze
  validates_numericality_of :score, greater_than_or_equal_to: 0, less_than_or_equal_to: 5, on: :create

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
