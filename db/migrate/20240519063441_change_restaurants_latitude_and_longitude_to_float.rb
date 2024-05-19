class ChangeRestaurantsLatitudeAndLongitudeToFloat < ActiveRecord::Migration[7.1]
  def change
    change_table :restaurants do |t|
      t.change :latitude, :float
      t.change :longitude, :float
    end
  end
end
