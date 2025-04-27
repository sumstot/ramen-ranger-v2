class RemoveSortOrderFromReviewImage < ActiveRecord::Migration[7.2]
  def change
    remove_column :review_images, :sort_order
  end
end
