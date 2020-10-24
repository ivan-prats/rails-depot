require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success

    assert_select 'nav a', minimum: 4
    assert_select 'main [data-semantic="product-card"]', Product.count
    assert_select 'h2', products(:ruby).title
    assert_select 'main [data-semantic="price"]', /\$[,\d]+\.\d\d/
  end

end
