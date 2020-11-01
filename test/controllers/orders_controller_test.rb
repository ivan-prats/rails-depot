require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test 'should get index' do
    get orders_url
    assert_response :success
  end

  test 'should get redirected on new if cart is empty' do
    get new_order_url
    assert_redirected_to store_index_path
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test 'should get new if cart is NOT empty' do
    post line_items_url, params: { product_id: products(:ruby).id }

    cart = Cart.find(session[:cart_id])
    assert cart.line_items.empty? == false

    get new_order_url
    assert_response :success
  end

  test 'cart buttons should be hidden in new order (checkout page)' do
    post line_items_url, params: { product_id: products(:ruby).id }
    get new_order_url
    assert_response :success

    # I would prefer to assert the CSS property "display" of the buttons, but dunno how to do it
    assert_select '#cart .button_to .hide-on-orders', 4
    assert_select '#cart .button_to', 4
  end

  test 'should NOT create order if there is nothing in the cart' do
    assert_no_difference('Order.count') do
      post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    end
    assert_redirected_to store_index_url
  end

  test 'should create order if there is at least one item in the cart' do
    post line_items_url, params: { product_id: products(:ruby).id }
    assert_difference('Order.count', 1) do
      post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    end

    order = Order.all.last
    assert_equal order.line_items.size, 1
    assert_equal order.line_items.first.product_id, products(:ruby).id

    assert_redirected_to store_index_url
    assert_equal flash[:notice], 'Thank you for your order!'
    assert_equal flash[:notice_type], 'success'
  end

  test 'should delete current cart from DB and from session after creating an order' do
    post line_items_url, params: { product_id: products(:ruby).id }

    current_cart_id = session[:cart_id]
    assert_not_nil current_cart_id

    assert_difference('Order.count', 1) do
      post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    end

    assert_nil(session[:cart_id])
    assert_raises(ActiveRecord::RecordNotFound) do
      Cart.find(current_cart_id)
    end
  end

  test 'should show order' do
    get order_url(@order)
    assert_response :success
  end

  test 'should get edit' do
    get edit_order_url(@order)
    assert_response :success
  end

  test 'should update order' do
    patch order_url(@order), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    assert_redirected_to order_url(@order)
  end

  test 'should destroy order' do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
