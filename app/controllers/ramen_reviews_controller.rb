class RamenReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_selected_restaurant, only: %i[new edit]
  before_action :set_ramen_review, only: %i[show edit]

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def new
    @ramen_review = RamenReview.new
    @review_image = @ramen_review.review_images.build
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.distinct(true).limit(5)
    render partial: 'restaurant_search_results', restaurants: @restaurants if turbo_frame_request?
  end

  def show; end

  def edit
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.distinct(true).limit(5)
    @existing_images = @ramen_review.review_images.order(:position).includes(image_attachment: :blob).map do |review_image|
      if review_image.image.attached?
        {
          url: url_for(review_image.image)
        }
      end
    end.compact
  end

  def create
    @ramen_review = RamenReview.new(ramen_review_params)
    if @ramen_review.save
      redirect_to edit_ramen_review_url(@ramen_review), notice: 'sucessfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(:soup, :score, :review, :price, :restaurant_id, :content, review_images_attributes: [:image, :position])
  end

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end

  def set_selected_restaurant
    @selected_restaurant = Restaurant.find(params[:selected_restaurant_id]) if params[:selected_restaurant_id].present?
  end
end
