class Restaurant < ApplicationRecord
  has_many :ramen_reviews, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def update_average_score
    update(average_score: ramen_reviews.average(:score).round(2))
  end
end
