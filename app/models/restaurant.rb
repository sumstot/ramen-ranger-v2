class Restaurant < ApplicationRecord
  include Favoritable
  extend Enumerize
  has_many :ramen_reviews, dependent: :destroy

  validates :name, presence: true
  validates :jpn_name, presence: true
  validates :address, presence: true
  validates :prefecture, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  serialize :days_closed, type: Array, coder: JSON
  enumerize :days_closed, in: %i[monday tuesday wednesday thursday friday saturday sunday holiday none], multiple: true, default: []

  def update_average_score
    update(average_score: ramen_reviews.average(:score).round(2))
  end

  def display_images
    first_images = fetch_first_images.compact
    additional_images = fetch_additional_images(first_images) if first_images.size < 3
    (first_images + additional_images.to_a).uniq(&:id)
  end

  private

  def fetch_first_images
    ramen_reviews.order(id: :desc)
                 .flat_map { |ramen_review| ramen_review.review_images.order(id: :desc).first }
                 .take(3)
  end

  def fetch_additional_images(first_images)
    all_images = ramen_reviews.flat_map { |review| review.review_images.order(id: :desc) }
    remaining_images = all_images - first_images
    remaining_images.first(3 - first_images.size)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title content soup name jpn_name station city prefecture]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ramen_reviews]
  end
end
