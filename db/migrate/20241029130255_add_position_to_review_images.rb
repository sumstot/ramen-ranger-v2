class AddPositionToReviewImages < ActiveRecord::Migration[7.2]
  def change
    add_column :review_images, :position, :integer
  end
end
