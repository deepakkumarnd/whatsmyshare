class CreatePriceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :price_histories do |t|
      t.string :f_date
      t.string :f_series
      t.string :f_open
      t.string :f_high
      t.string :f_low
      t.string :f_prev_close
      t.string :f_ltp
      t.string :f_close
      t.string :f_vwap
      t.string :f_52wh
      t.string :f_52wl
      t.string :f_volume
      t.string :f_value
      t.string :f_no_trades
    end
  end
end
