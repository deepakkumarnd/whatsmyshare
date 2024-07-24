class Payer < ApplicationRecord
  belongs_to :expense

  def to_data
    {
      id: self.id,
      name: self.name,
      amount: self.amount
    }
  end
end
