class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :address, default: '', null: false
      t.decimal :latitude, precision: 10, scale: 6, default: 0.0, null: false
      t.decimal :longitude, precision: 10, scale: 6, default: 0.0, null: false
      t.string :name, default: '', null: false
      t.string :jpn_name, default: '', null: false
      t.float :average_score, default: 0, null: false
      t.date :year_opened, default: "DATE_PART('year', CURRENT_DATE)::integer", null: false
      t.string :station, default: ''
      t.string :city, default: '', null: false
      t.string :prefecture, default: '', null: false

      t.timestamps
    end
  end
end
