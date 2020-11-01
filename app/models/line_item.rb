class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  before_save { self.total_price = total_price }

  def total_price
    quantity * product.price
  end
end
