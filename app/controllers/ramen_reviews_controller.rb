class RamenReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_selected_restaurant, only: %i[new edit]
  before_action :set_ramen_review, only: %i[show edit update]

  def index
    @view_type = params[:view]&.in?(['card', 'grid']) ? params[:view] : 'card'
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @pagy, @ramen_reviews = pagy(@q.result.includes(:restaurant).distinct(true))

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
    @ramen_review = RamenReview.includes(review_images: {image_attachment: :blob}).find(params[:id])
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.distinct(true).limit(5)
  end

  def create
    @ramen_review = RamenReview.new(ramen_review_params)
    if @ramen_review.save
      redirect_to ramen_review_url(@ramen_review), notice: 'sucessfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @ramen_review.update(ramen_review_params)
      redirect_to ramen_review_url(@ramen_review), notice: 'succesfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(
      :soup, :score, :review, :price, :restaurant_id, :content,
      review_images_attributes: [:id, :blob_signed_id, :position, :_destroy]
    )
  end

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end

  def set_selected_restaurant
    @selected_restaurant = Restaurant.find(params[:selected_restaurant_id]) if params[:selected_restaurant_id].present?
  end
end
