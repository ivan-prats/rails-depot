require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  test 'should always show the correct total_price' do
    cart = Cart.create
    line_item = LineItem.new({ product: products(:ruby), cart: cart })

    assert_operator line_item.total_price, :==, products(:ruby).price * line_item.quantity

    line_item.quantity += 1
    assert_operator line_item.total_price, :==, products(:ruby).price * line_item.quantity
    line_item.quantity += 2
    assert_operator line_item.total_price, :==, products(:ruby).price * line_item.quantity
    line_item.quantity = 0
    assert_operator line_item.total_price, :==, products(:ruby).price * line_item.quantity
  end

  test 'should always save into DB the correct total_price' do
    cart = Cart.create
    quantity = 123_456
    line_item = LineItem.create({ product: products(:ruby), cart: cart, quantity: quantity })
    assert_operator line_item.total_price, :==, products(:ruby).price * quantity

    line_item_by_quantity = LineItem.find_by total_price: products(:ruby).price * quantity
    assert(line_item_by_quantity.id == line_item.id)

    updated_quantity = quantity + 10
    line_item.quantity = updated_quantity
    assert line_item.save
    line_item_by_quantity = LineItem.find_by total_price: products(:ruby).price * updated_quantity
    assert(line_item_by_quantity.id == line_item.id)
  end
end
