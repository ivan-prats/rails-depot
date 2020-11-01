require 'application_system_test_case'

class LineItemsTest < ApplicationSystemTestCase
  setup do
    @line_item = line_items(:one)
  end

  test 'adding a line_item in the store_index page shows it and the cart' do
    visit store_index_url

    assert_no_selector '#cart table'
    click_on 'Add to Cart', match: :first
    assert_selector '#cart table tbody tr'
  end

  test 'adding a line_item in the store_index page highlights the added line item' do
    visit store_index_url

    assert_no_selector '#cart table'
    click_on 'Add to Cart', match: :first
    assert_selector '#cart table .line-item-highlight'

    visit store_index_url
    assert_selector '#cart table'
    assert_no_selector '#cart table .line-item-highlight'
  end

  test 'click on delete button of a line_item from the cart erases it as well' do
    visit store_index_url

    assert_no_selector '#cart table'
    click_on 'Add to Cart', match: :first
    assert_selector '#cart table .line-item-highlight'

    find('#cart table .line-item-highlight button[data-semantic="button_delete"]').click
    assert_no_selector '.line-item-highlight'
  end

  test 'adding to cart twice the same product shows on the cart quantity' do
    visit store_index_url

    assert_no_selector '#cart table'
    click_on 'Add to Cart', match: :first
    assert_selector "#cart .line-item-highlight span[data-semantic='line_item.quantity']", text: '1'

    click_on 'Add to Cart', match: :first
    assert_selector "#cart .line-item-highlight span[data-semantic='line_item.quantity']", text: '2'
  end

  test 'adding to cart twice the same product, and then decreasing the line_item quantity works as intended' do
    visit store_index_url

    assert_no_selector '#cart table'
    click_on 'Add to Cart', match: :first
    click_on 'Add to Cart', match: :first
    assert_selector "#cart .line-item-highlight span[data-semantic='line_item.quantity']", text: '2'

    find('#cart table .line-item-highlight button[data-semantic="button_decrease_quantity"]').click
    assert_selector "#cart .line-item-highlight span[data-semantic='line_item.quantity']", text: '1'
    find('#cart table .line-item-highlight button[data-semantic="button_decrease_quantity"]').click
    assert_no_selector '.line-item-highlight'
  end

  # test 'visiting the index' do
  #   visit line_items_url
  #   assert_selector 'h1', text: 'Line Items'
  # end

  # test 'creating a Line item' do
  #   visit line_items_url
  #   click_on 'New Line Item'

  #   fill_in 'Cart', with: @line_item.cart_id
  #   fill_in 'Product', with: @line_item.product_id
  #   click_on 'Create Line item'

  #   assert_text 'Line item was successfully created'
  #   click_on 'Back'
  # end

  # test 'updating a Line item' do
  #   visit line_items_url
  #   click_on 'Edit', match: :first

  #   fill_in 'Cart', with: @line_item.cart_id
  #   fill_in 'Product', with: @line_item.product_id
  #   click_on 'Update Line item'

  #   assert_text 'Line item was successfully updated'
  #   click_on 'Back'
  # end

  # test 'destroying a Line item' do
  #   visit line_items_url
  #   page.accept_confirm do
  #     click_on 'Destroy', match: :first
  #   end

  #   assert_text 'Line item was successfully deleted'
  # end
end
