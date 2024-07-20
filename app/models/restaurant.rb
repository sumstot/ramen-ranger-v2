class Restaurant < ApplicationRecord
  has_many :ramen_reviews, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validate :validate_days_closed if proc { days_closed.present? }

  DAYS_OF_WEEK = %w[Sun Mon Tues Wed Thrs Fri Sat Holiday].freeze

  def update_average_score
    update(average_score: ramen_reviews.average(:score).round(2))
  end

  def display_images
    first_images = ramen_reviews.order(id: :desc).flat_map { |ramen_review| ramen_review.review_images.first }.first(3)
    binding.pry
    if ramen_reviews.count < 3
      remaining_images = ramen_reviews.order(id: :desc).flat_map(&:review_images).reject { |img| first_images.include?(img) }
      remaining_images.take(3 - first_images.size)
    else
      first_images
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title content soup name jpn_name station city prefecture]
  end

  def display_days_closed
    days_closed.map { |day| DAYS_OF_WEEK[day] }.join(', ')
  end
end
