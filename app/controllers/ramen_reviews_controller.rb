class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

  def index
    # @query = RamenReview.ransack(params[:q])
    @ramen_reviews = RamenReview.all.includes(:review_images)
  end
end
