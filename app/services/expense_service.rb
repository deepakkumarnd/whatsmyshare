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
end