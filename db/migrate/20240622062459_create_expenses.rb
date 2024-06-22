class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 8, scale: 2, default: 0

      t.timestamps
    end
  end
end
