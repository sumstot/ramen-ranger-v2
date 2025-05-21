class ChangeColumnRestaurantsDaysClosedToString < ActiveRecord::Migration[8.0]
  def change
    change_column :restaurants, :days_closed, :string
  end
end
