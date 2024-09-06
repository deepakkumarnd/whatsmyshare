class Stock < ApplicationRecord
  has_many :price_histories, dependent: :delete_all
  has_one_attached :price_history
end
