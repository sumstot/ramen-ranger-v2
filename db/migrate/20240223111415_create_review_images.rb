class CreateReviewImages < ActiveRecord::Migration[7.1]
  def change
    create_table :review_images do |t|
      t.integer :sort_order, default: 0
      t.belongs_to :ramen_review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
