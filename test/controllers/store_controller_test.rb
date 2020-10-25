require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success

    assert_select 'nav a', minimum: 4
    assert_select 'main [data-semantic="product-card"]', Product.count
    assert_select 'h2', products(:ruby).title
    assert_select 'main [data-semantic="price"]', /\€[,\d]+\.\d\d/
  end

  test "should increment store_counter when getting index" do
    get store_index_url
    assert_response :success

    assert_not_nil session[:store_counter] 
    assert_difference ->{ session[:store_counter] }, 1 do
      get store_index_url
    end
  end

  test "show store_counter in store#index" do
    get store_index_url
    assert_response :success

    assert_select 'span[data-semantic="store_counter"]', session[:store_counter]
  end
end
