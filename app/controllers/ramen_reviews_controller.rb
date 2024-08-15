class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

  def index
    @q = RamenReview.includes(:review_images).ransack(params[:q])
    @ramen_reviews = @q.result.includes(:restaurant).distinct(true)
  end

  def new

  end

  def create

  end
end
