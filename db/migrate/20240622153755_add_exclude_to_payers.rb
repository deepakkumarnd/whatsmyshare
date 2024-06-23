class AddExcludeToPayers < ActiveRecord::Migration[7.1]
  def change
    add_column :payers, :exclude, :boolean
  end
end
