class Restaurants::FavoritesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_restaurant

  def update
    # binding.pry
    if @restaurant.favorited_by?(current_user)
      @restaurant.unfavorite(current_user)
    else
      @restaurant.favorite(current_user)
    end

    render partial: "restaurants/favorite", locals: { restaurant: @restaurant, current_user: current_user }
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
