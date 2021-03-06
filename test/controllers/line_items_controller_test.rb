require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # We create and set a Cart with a :ruby product, this will be in the session
    post line_items_url, params: { product_id: products(:one).id }
    @cart = Cart.find(session[:cart_id])
    @line_item = @cart.line_items.first
  end

  test 'should get index' do
    get line_items_url
    assert_response :success
  end

  test 'should get new' do
    get new_line_item_url
    assert_response :success
  end

  test 'should create line_item' do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!
    assert_select 'h2', 'Your Pragmatic Cart'
    assert_select '#notice h3', 'Line item was successfully added.'
    assert_select '[data-semantic="line_item.product.title"]', products(:ruby).title
    assert_select '[data-semantic="line_item.quantity"]', '1'
    assert_select '[data-semantic="line_item.total_price"]', "€#{products(:ruby).price}0"
  end

  test 'should create line_item via ajax' do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end
    assert_response :success
    assert_match(/<tr id=\\"line_item-(\d*)\\"(\s*)class=\\"line-item-highlight/, @response.body)
  end

  test 'should reset store_counter when creating a line_item' do
    get store_index_url
    assert session[:store_counter] == 1

    post line_items_url, params: { product_id: products(:ruby).id }
    assert session[:store_counter] == 0
  end

  test 'should show line_item' do
    get line_item_url(@line_item)
    assert_response :success
  end

  test 'should get edit' do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test 'should update line_item' do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test 'should update line_item when increasing quantity' do
    initial_quantity = @line_item.quantity
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id, quantity: initial_quantity + 1 } }

    @line_item = @cart.line_items.first
    assert(@line_item.quantity == initial_quantity + 1)
    assert_redirected_to line_item_url(@line_item)
  end

  test 'should destroy the line_item if updating quantity to 0' do
    initial_line_item_id = @line_item.id
    patch line_item_url(@line_item), params: { line_item: { quantity: 0 } }
    assert_raises(ActiveRecord::RecordNotFound) do
      LineItem.find(initial_line_item_id)
    end
  end
  test 'should destroy the line_item if updating quantity to -1' do
    initial_line_item_id = @line_item.id
    patch line_item_url(@line_item), params: { line_item: { quantity: -1 } }
    assert_raises(ActiveRecord::RecordNotFound) do
      LineItem.find(initial_line_item_id)
    end
  end

  test 'should update line_item via ajax' do
    modified_quantity = 11_111
    line_item_id = @line_item.id
    put line_item_url(@line_item), params: { line_item: { quantity: modified_quantity } }, xhr: true

    assert_response :success
    assert_match(/<tr id=\\"line_item-#{@line_item.id}\\"(\s*)class=\\"line-item-highlight/, @response.body)
    assert_match(/<span data-semantic=\\"line_item.quantity\\">#{modified_quantity}/, @response.body)

    updated_line_item = LineItem.find(line_item_id)
    assert_operator updated_line_item.total_price, :==, updated_line_item.product.price * modified_quantity
  end

  test 'should destroy line_item' do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end
    assert_redirected_to cart_url(@cart)

    follow_redirect!
    assert_select '[data-semantic-flash-notice_type="success"]', 1
  end

  test 'should destroy line_item via ajax' do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item), xhr: true
    end
    assert_response :success
    assert_no_match(/#{@line_item.product.title}/, @response.body)
  end

  test "should not be able to delete a line_item in another user's cart" do
    # We try deleting a LineItem that is not on our current session cart
    assert_no_difference('LineItem.count') do
      delete line_item_url(line_items(:one))
    end
    assert_redirected_to store_index_url
  end
end
