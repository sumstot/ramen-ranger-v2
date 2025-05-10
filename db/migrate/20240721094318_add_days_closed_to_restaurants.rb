class AddDaysClosedToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :days_closed, :string, default: '[]'
  end
end
