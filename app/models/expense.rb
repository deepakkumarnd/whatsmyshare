class Expense < ApplicationRecord
  has_many :payers
  has_many :debtors
end
