class RamenReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_selected_restaurant, only: %i[new edit update]
  before_action :set_ramen_review, only: %i[show edit update]
  before_action :set_restaurant_search, only: %i[new edit update]
  # before_action :set_existing_images, only: %i[edit update]

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def new
    @ramen_review = RamenReview.new
    @review_image = @ramen_review.review_images.build
    render partial: 'restaurant_search_results', restaurants: @restaurants if turbo_frame_request?
  end

  def show; end

  def edit
    @existing_images = @ramen_review.review_images.order(:position).includes(image_attachment: :blob).map do |review_image|
      if review_image.image.attached?
        {
          signed_id: review_image.image.signed_id,
          url: url_for(review_image.image),
          position: review_image.position,
          id: review_image.id
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

  def update
    binding.pry
    if @ramen_review.update(ramen_review_params)
      redirect_to ramen_review_url(@ramen_review)
    else
      @existing_images = @ramen_review.review_images.order(:position).includes(image_attachment: :blob).map do |review_image|
        if review_image.image.attached?
          {
            url: url_for(review_image.image),
            position: review_image.position
          }
        end
      end.compact
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(
      :soup,
      :score,
      :review,
      :price,
      :restaurant_id,
      :content,
      # :existing_images,
      review_images_attributes: [:id, :image, :position, :_destroy]
    )
  end

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end

  def set_selected_restaurant
    @selected_restaurant = Restaurant.find(params[:selected_restaurant_id]) if params[:selected_restaurant_id].present?
  end

  def set_restaurant_search
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.distinct(true).limit(5)
  end

  def set_existing_images

  end
end
