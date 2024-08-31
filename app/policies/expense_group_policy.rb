class ExpenseGroupPolicy < ApplicationPolicy
  def settle?
    !record.settled?
  end

  def add_new_expense?
    !record.settled?
  end
end