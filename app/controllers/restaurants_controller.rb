class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
   :calculate_average_score

  def map
    @restaurants = Restaurant.all
    @markers = @restaurants.geocoded.map do |restaurant|
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude,
        color: helpers.star_color(restaurant.average_score)
      }
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
