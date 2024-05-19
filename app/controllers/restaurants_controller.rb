class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show

  def map
    @restaurants = Restaurant.all
    @markers = @restaurants.geocoded.map do |restaurant|
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude
      }
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
