class RamenReviews::FavoritesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_ramen_review

  def update
    if @ramen_review.favorited_by?(current_user)
      @ramen_review.unfavorite(current_user)
    else
      @ramen_review.favorite(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@ramen_review, :favorite),
          partial: 'ramen_reviews/favorite',
          locals: { ramen_review: @ramen_review, current_user: current_user }
        )
      end
    end
  end

  private

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:ramen_review_id])
  end
end
