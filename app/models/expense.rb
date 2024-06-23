class Expense < ApplicationRecord
  has_many :payers
  has_many :debtors

  validates :description, presence: true, length: { minimum: 2, maximum: 256 }
  validates :amount, presence: true, numericality: { greater_than: 0, less_than: 1_0000_0000 }

  accepts_nested_attributes_for :payers, allow_destroy: true
  accepts_nested_attributes_for :debtors, allow_destroy: true
end
