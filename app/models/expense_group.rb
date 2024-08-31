class ExpenseGroup < ApplicationRecord
  validates :description, presence: true, length: { minimum: 4, maximum: 255 }

  has_many :expenses

  def summary
    summary_mapping = {}
    payers_summary_mapping = {}
    debtors_summary_mapping = {}

    expenses.each do |expense|
      expense.debtors.each do |debtor|
        debtors_summary_mapping[debtor.name] = (debtors_summary_mapping[debtor.name] || 0) + debtor.amount
      end
    end

    expenses.each do |expense|
      expense.payers.each do |payer|
        if payer.amount > expense.amount_per_participant
          payers_summary_mapping[payer.name] = (payers_summary_mapping[payer.name] || 0) + payer.amount - expense.amount_per_participant
        end
      end
    end

    summary_mapping[:debt] = debtors_summary_mapping
    summary_mapping[:payer] = payers_summary_mapping
    summary_mapping
  end
end
