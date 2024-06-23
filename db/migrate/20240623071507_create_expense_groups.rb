class CreateExpenseGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_groups do |t|
      t.string :description

      t.timestamps
    end
  end
end
