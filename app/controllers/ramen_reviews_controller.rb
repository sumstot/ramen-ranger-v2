class RamenReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_ramen_review, only: %i[show]

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def new
    @ramen_review = RamenReview.new
    @review_image = @ramen_review.review_images.build
  end

  def create
    @ramen_review = RamenReview.new(ramen_review_params)
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(:soup, :score, :review, :price, :restaurant_id, review_images: [:media])
  end
end
