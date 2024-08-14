class Restaurant < ApplicationRecord
  has_many :ramen_reviews, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  DAYS_OF_WEEK = %w[Sun Mon Tues Wed Thrs Fri Sat Holiday].freeze

  def update_average_score
    update(average_score: ramen_reviews.average(:score).round(2))
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title content soup name jpn_name station city prefecture]
  end

  def display_days_closed
    days_closed.map { |day| DAYS_OF_WEEK[day] }.join(', ')
  end
end
