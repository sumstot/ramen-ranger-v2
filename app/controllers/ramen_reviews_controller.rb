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
  end

  def create
    binding.pry
    @ramen_review = RamenReview.new(ramen_review_params)
    if @ramen_review.save
      redirect_to edit_ramen_review_url(@ramen_review), notice: 'sucessfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def upload_image
    @review_image = @review.review_images.build(image: params[:image])
    # if @review_image.save
    #   render turbo_stream: [
    #     turbo_stream.append('turbo-uploaded-images',
    #                         partial: 'reviews/review_image_preview',
    #                         locals: { review_image: @review_image }),
    #     turbo_stream.update('upload-notice', 'Image uploaded successfully!')
    #   ]
    # else
    #   render turbo_stream: turbo_stream.update('upload-notice', 'Failed to upload image')
    # end
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(:soup, :score, :review, :price, :restaurant_id, :content, review_images_attributes: [:image])
  end

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end

  def set_selected_restaurant
    @selected_restaurant = Restaurant.find(params[:selected_restaurant_id]) if params[:selected_restaurant_id].present?
  end
end
