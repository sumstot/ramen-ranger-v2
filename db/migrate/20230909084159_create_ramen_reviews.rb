class CreateRamenReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :ramen_reviews do |t|
      t.string :soup, default: '', null: false
      t.float :score
      t.text :review, default: '', null: false
      t.bigint :price, default: 0, null: false
      t.references :restaurant, foreign_key: true
      t.integer :likes_count, default: 0, null: false
      
      t.timestamps
    end
  end
end
