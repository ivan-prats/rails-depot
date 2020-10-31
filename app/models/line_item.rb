class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  before_save :set_total_price
  def total_price
    quantity * product.price
  end

  private

  def set_total_price
    self.total_price = total_price
  end
end
