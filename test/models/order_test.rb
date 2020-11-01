require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'add_line_items_from_cart should add the line_items to the order and take them out of the cart' do
    # We build a Cart in session
    cart = Cart.new
    cart.add_product(products(:ruby))
    cart.add_product(products(:two))

    order = Order.new
    order.add_line_items_from_cart(cart)

    assert_equal order.line_items.size, 2
    assert_equal order.line_items[0].product_id, products(:ruby).id
    assert_equal order.line_items[1].product_id, products(:two).id
    order.line_items.each do |item|
      assert_nil item.cart_id
    end
  end
end
