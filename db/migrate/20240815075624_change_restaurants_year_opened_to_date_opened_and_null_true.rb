class ChangeRestaurantsYearOpenedToDateOpenedAndNullTrue < ActiveRecord::Migration[7.2]
  def change
    rename_column :restaurants, :year_opened, :date_opened
    change_column_null :restaurants, :date_opened, true
  end
end
