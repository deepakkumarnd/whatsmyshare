class GroupExpensesToExpenseGroups < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :expense_group, foreign_key: true, null: false, index: true
  end
end
