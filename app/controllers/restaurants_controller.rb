class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
  before_action :store_referer, only: :new

  def index
    @pagy, @restaurants = pagy(Restaurant.all)
  end

  def new
    @restaurant = Restaurant.new
  end

  def show; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to return_url(@restaurant)
    else
      render :new, status: :unprocessable_entity
    end
  end

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

  def hall_of_fame; end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:address, :name, :jpn_name, :date_opened, :station, :city, :prefecture, :days_closed)
  end

  def store_referer
    session[:back_path] = request.referer if request.referer.present?
  end

  def return_url(restaurant)
    if session[:back_path]&.include?('ramen_reviews/new')
      session.delete(:back_path)
      new_ramen_review_path(selected_restaurant_id: restaurant.id)
    else
      restaurant_path(restaurant)
    end
  end
end
