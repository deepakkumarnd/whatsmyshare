class ExpenseGroup < ApplicationRecord
  validates :description, presence: true, length: { minimum: 4, maximum: 255 }

  has_many :expenses, dependent: :destroy
end
