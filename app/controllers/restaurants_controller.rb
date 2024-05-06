class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show

  def map
    # render 'shared/map'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
