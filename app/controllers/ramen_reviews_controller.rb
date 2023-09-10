class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

  def index
    @query = RamenReview.ransack(params[:q])
  end
end
