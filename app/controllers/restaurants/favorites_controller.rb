class Restaurants::FavoritesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_restaurant

  def update
    if @restaurant.favorited_by?(current_user)
      @restaurant.unfavorite(current_user)
    else
      @restaurant.favorite(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@restaurant, :favorite),
          partial: 'restaurants/favorite',
          locals: { restaurant: @restaurant, current_user: current_user }
        )
      end
    end
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
