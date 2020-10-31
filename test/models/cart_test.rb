require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "should add product to cart when it's new" do
    cart = Cart.new
    new_line_item = cart.add_product products(:ruby)

    assert new_line_item.quantity == 1
    assert new_line_item.total_price == products(:ruby).price
    assert cart.line_items.size == 1
    assert new_line_item.save
  end

  test 'should up quantity by 1 when adding an already existing product' do
    cart = Cart.new
    new_line_item = cart.add_product products(:ruby)
    assert new_line_item.quantity == 1
    assert new_line_item.save

    reapated_line_item = cart.add_product products(:ruby)
    assert cart.line_items.size == 1
    assert reapated_line_item.quantity == 2
    assert_operator reapated_line_item.total_price, :==, (products(:ruby).price * reapated_line_item.quantity)
  end
end
