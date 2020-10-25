class AddTotalPriceToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :total_price, :decimal, precision: 8, scale: 2
  end
end
