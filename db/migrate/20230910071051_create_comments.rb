class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :comment, default: '', null: false
      t.integer :likes_count, default: 0
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :ramen_review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
