class CreateDebtors < ActiveRecord::Migration[7.1]
  def change
    create_table :debtors do |t|
      t.string :name
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
