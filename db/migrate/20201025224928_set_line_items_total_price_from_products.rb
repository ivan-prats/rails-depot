class SetLineItemsTotalPriceFromProducts < ActiveRecord::Migration[6.0]
  def up
    LineItem.all.each do |line_item|
      line_item.total_price = line_item.quantity * line_item.product.price
      line_item.save
    end
  end
end
