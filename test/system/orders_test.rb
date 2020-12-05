require 'application_system_test_case'

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test 'visiting the index' do
    visit orders_url
    assert_selector 'h1', text: 'Orders'
  end

  test 'creating a Order' do
    visit store_index_url
    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'Address', with: @order.address
    fill_in 'Email', with: @order.email
    fill_in 'Name', with: @order.name
    select 'Check', from: 'Pay type'
    click_on 'Place Order'

    assert_text 'Thank you for your order!'
  end

  test 'check extra inputs appear while Creating a Order, if Pay Type "Check" is selected' do
    visit store_index_url
    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'Address', with: @order.address
    fill_in 'Email', with: @order.email
    fill_in 'Name', with: @order.name

    assert_no_selector '#order_routing_number'
    assert_no_selector '#order_account_number'
    select 'Check', from: 'Pay type'
    assert_selector '#order_routing_number'
    assert_selector '#order_account_number'

    # Make sure the rest of inputs remain hidden
    assert_no_selector '#order_po_number'
    assert_no_selector '#order_credit_card_number'
    assert_no_selector '#order_expiration_date'
  end

  test 'check extra inputs appear while Creating a Order, if Pay Type "Credit card" is selected' do
    visit store_index_url
    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'Address', with: @order.address
    fill_in 'Email', with: @order.email
    fill_in 'Name', with: @order.name

    assert_no_selector '#order_credit_card_number'
    assert_no_selector '#order_expiration_date'
    select 'Credit card', from: 'Pay type'
    assert_selector '#order_credit_card_number'
    assert_selector '#order_expiration_date'

    # Make sure the rest of inputs remain hidden
    assert_no_selector '#order_po_number'
    assert_no_selector '#order_routing_number'
    assert_no_selector '#order_account_number'
  end

  test 'check extra inputs appear while Creating a Order, if Pay Type "Purchase order" is selected' do
    visit store_index_url
    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'Address', with: @order.address
    fill_in 'Email', with: @order.email
    fill_in 'Name', with: @order.name

    assert_no_selector '#order_po_number'
    select 'Purchase order', from: 'Pay type'
    assert_selector '#order_po_number'

    # Make sure the rest of inputs remain hidden
    assert_no_selector '#order_credit_card_number'
    assert_no_selector '#order_expiration_date'
    assert_no_selector '#order_routing_number'
    assert_no_selector '#order_account_number'
  end

  test 'checkout process with "Check" pay_type' do
    LineItem.delete_all
    Order.delete_all
    visit store_index_url

    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'Address', with: 'Some randomass address'
    fill_in 'Email', with: 'some@randomassemail.com'
    fill_in 'Name', with: 'Some randomass name'

    assert_no_selector '#order_routing_number'
    assert_no_selector '#order_account_number'
    select 'Check', from: 'Pay type'
    assert_selector '#order_routing_number'
    assert_selector '#order_account_number'

    fill_in 'Routing #',	with: '123456'
    fill_in 'Account #',	with: '987654'

    perform_enqueued_jobs do
      click_button 'Place Order'
    end

    orders = Order.all
    assert_equal orders.size, 1

    order = orders.first
    assert_equal order.name, 'Some randomass name'
    assert_equal order.address, 'Some randomass address'
    assert_equal order.email, 'some@randomassemail.com'
    assert_equal order.pay_type, 'Check'
    assert_equal order.line_items.size, 1

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['some@randomassemail.com'], mail.to
    assert_equal 'Ivan Ruby <ivanprats@hey.com>', mail[:from].value
    assert_equal "Your Pragmatic order ##{order.id} confirmation", mail.subject
  end

  # test 'updating a Order' do
  #   visit orders_url
  #   click_on 'Edit', match: :first

  #   fill_in 'Address', with: @order.address
  #   fill_in 'Email', with: @order.email
  #   fill_in 'Name', with: @order.name
  #   fill_in 'Pay type', with: @order.pay_type
  #   click_on 'Update Order'

  #   assert_text 'Order was successfully updated'
  #   click_on 'Back'
  # end

  test 'destroying a Order' do
    visit orders_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Order was successfully destroyed'
  end
end
