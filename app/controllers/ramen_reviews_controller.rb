class RamenReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_ramen_review, only: %i[show]

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def show

  end

  private

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end
end
