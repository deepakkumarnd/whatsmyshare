class ExpenseService
  include Singleton

  def build_expense(expense)
    expense.amount = expense.payers.map(&:amount).reduce(:+)
    participants_count = expense.payers.filter { |x| !x.exclude }.length + expense.debtors.length
    expense.amount_per_participant = expense.amount / participants_count

    amount_per_participant = expense.amount_per_participant

    expense.debtors.each do |debtor|
      debtor.amount = amount_per_participant
    end

    expense.payers.each do |payer|
      if payer.amount < amount_per_participant
        diff = amount_per_participant - payer.amount

        # look for existing debtor when it comes to updates
        debtor = expense.debtors.find { |debtor| debtor.name == payer.name }

        if debtor.present?
          debtor.amount = diff
        else
          expense.debtors.build(name: payer.name, amount: diff)
        end
      end
    end

    expense
  end

  def build_summary(expense_group)
    summary_mapping = {}
    payers_summary_mapping = {}
    debtors_summary_mapping = {}

    expense_group.expenses.each do |expense|
      expense.debtors.each do |debtor|
        debtors_summary_mapping[debtor.name] = (debtors_summary_mapping[debtor.name] || 0) + debtor.amount
      end

      expense.payers.each do |payer|
        if payer.amount > expense.amount_per_participant
          payers_summary_mapping[payer.name] = (payers_summary_mapping[payer.name] || 0) + payer.amount - expense.amount_per_participant
        end
      end
    end

    # keep only the net amount inflow/outflow
    (debtors_summary_mapping.keys & payers_summary_mapping.keys).each do |key|
      if payers_summary_mapping[key] > debtors_summary_mapping[key]
        payers_summary_mapping[key] = payers_summary_mapping[key] - debtors_summary_mapping[key]
        debtors_summary_mapping.delete(key)
      elsif payers_summary_mapping[key] < debtors_summary_mapping[key]
        debtors_summary_mapping[key] = debtors_summary_mapping[key] - payers_summary_mapping[key]
        payers_summary_mapping.delete(key)
      else
        payers_summary_mapping.delete(key)
        debtors_summary_mapping.delete(key)
      end
    end

    summary_mapping[:debt] = debtors_summary_mapping
    summary_mapping[:payer] = payers_summary_mapping
    summary_mapping
  end
end