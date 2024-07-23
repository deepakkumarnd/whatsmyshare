class ExpenseService
  include Singleton

  def create_expense(expense_params)
    expense = Expense.new
    expense.description = expense_params[:description]
    expense.amount = expense_params[:payers].map{ |p| p[:amount].to_i }.reduce(:+)
    expense.save!

    payers = expense_params[:payers].map do |payer|
      expense.payers.new(name: payer[:name], amount: payer[:amount].to_i, exclude: payer[:exclude])
    end

    debtors = expense_params[:debtors].map do |debtor|
      expense.debtors.new(name: debtor[:name])
    end

    ActiveRecord::Base.transaction do
      payers.each { |payer| payer.save! }
      debtors.each { |debtor| debtor.save! }
    end

    expense
  end
end