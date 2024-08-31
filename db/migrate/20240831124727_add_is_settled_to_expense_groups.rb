class AddIsSettledToExpenseGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_groups, :is_settled, :boolean, default: false
  end
end
