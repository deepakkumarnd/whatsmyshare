class CreatePayers < ActiveRecord::Migration[7.1]
  def change
    create_table :payers do |t|
      t.string :name
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.references :expenses, null: false, foreign_key: true

      t.timestamps
    end
  end
end
