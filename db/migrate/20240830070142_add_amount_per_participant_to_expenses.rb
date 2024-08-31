class AddAmountPerParticipantToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :amount_per_participant, :decimal, default: 0
  end
end
