class ScrapedData < ApplicationRecord
  validates :brand, :model, :price, presence: true
end
