class ExpenseGroup < ApplicationRecord
  validates :description, presence: true, length: { minimum: 4, maximum: 255 }

  has_many :expenses, dependent: :destroy

  def settled?
    is_settled
  end
end
