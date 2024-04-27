class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

  def index
    @query = RamenReview.ransack(params[:q])
    # @ramen_reviews = @ramen_reviews.all.includes(:ramen_review_photos)
  end
end
