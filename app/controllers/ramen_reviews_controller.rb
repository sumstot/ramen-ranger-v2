class RamenReviewsController < ApplicationController

  before_action :authenticate_user!

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

  def upload_image
    @review_image = @review.review_images.build(image: params[:image])

    if @review_image.save
      render turbo_stream: [
        turbo_stream.append('uploaded-images',
                            partial: 'reviews/review_image_preview',
                            locals: { review_image: @review_image }),
        turbo_stream.update('upload-notice', 'Image uploaded successfully!')
      ]
    else
      render turbo_stream: turbo_stream.update('upload-notice', 'Failed to upload image')
    end
  end

  private

  def ramen_review_params
    params.require(:ramen_review).permit(:soup, :score, :review, :price, :restaurant_id, review_images_attributes: [:image])
  end

  def set_ramen_review
    @ramen_review = RamenReview.find(params[:id])
  end
end
