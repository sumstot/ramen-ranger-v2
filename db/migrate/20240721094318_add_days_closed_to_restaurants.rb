class AddDaysClosedToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :days_closed, :integer, array: true, default: []
  end
end
