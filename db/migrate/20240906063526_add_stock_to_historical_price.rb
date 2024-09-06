class AddStockToHistoricalPrice < ActiveRecord::Migration[7.1]
  def change
    add_reference :price_histories, :stock, foreign_key: true, null: false, index: true
  end
end
