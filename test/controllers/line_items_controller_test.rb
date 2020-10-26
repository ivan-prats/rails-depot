require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # We create and set a Cart with a :ruby product, this will be in the session
    post line_items_url, params: { product_id: products(:one).id }
    @cart = Cart.find(session[:cart_id])
    @line_item = @cart.line_items.first
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!
    assert_select 'h2', 'Your Pragmatic Cart'
    assert_select '#notice h3', 'Line item was successfully added.'
    assert_select '[data-semantic="line_item.product.title"]', products(:ruby).title
    assert_select '[data-semantic="line_item.quantity"]', "1"
    assert_select '[data-semantic="line_item.total_price"]', "€#{products(:ruby).price}0"
  end

  test "should reset store_counter when creating a line_item" do
    get store_index_url 
    assert session[:store_counter] == 1

    post line_items_url, params: { product_id: products(:ruby).id }
    assert session[:store_counter] == 0
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end
    assert_redirected_to cart_url(@cart)

    follow_redirect!
    assert_select '[data-semantic-flash-notice_type="success"]', 1
  end

  test "should not be able to delete a line_item in another user's cart" do
    # We try deleting a LineItem that is not on our current session cart
    assert_no_difference('LineItem.count') do
      delete line_item_url(line_items(:one))
    end
    assert_redirected_to store_index_url 

  end

end
