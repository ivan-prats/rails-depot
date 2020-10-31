class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  before_save { self.total_price = total_price }

  def total_price
    quantity * product.price
  end
end
