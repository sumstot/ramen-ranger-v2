class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
   :calculate_average_score

  def index
    @restaurants = Restaurant.all
  end

  def map
    @restaurants = Restaurant.all

    @markers = @restaurants.geocoded.map do |restaurant|
      @review_images = restaurant.ramen_reviews.flat_map(&:review_images).take(10)
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude,
        color: helpers.star_color(restaurant.average_score),
        info_window: render_to_string(partial: 'restaurants/info_window', locals: { restaurant:, review_images: @review_images })
      }
    end
  end

  def hall_of_fame

  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
