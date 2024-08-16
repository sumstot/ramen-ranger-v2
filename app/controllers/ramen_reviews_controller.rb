class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def new
    @ramen_review = RamenReview.new
  end

  def create
    @ramen_review = RamenReview.new(ramen_review_params)
  end

  private

  def ramen_review_params
  end
end
