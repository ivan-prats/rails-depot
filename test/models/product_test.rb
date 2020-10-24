require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do 
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new title: "My Book Title", description: "My description", image_url: "abc.jpg"

    product.price = -1 
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0 
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new title: "My Book Title", description: "My description", price: 1, image_url: image_url
  end

  test "image url" do
    ok_image_urls = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/u/z/fred.gif }
    bad_image_urls = %w{ fred.doc fred.gif/more fred.gif.more fred.pdf fred.xls }

    ok_image_urls.each do |image_url| 
      assert new_product(image_url).valid?, "#{image_url} should't be invalid"
    end

    bad_image_urls.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} should't be valid"
    end
  end
  
  test "product is not valid without a unique title - i18n" do 
    product = Product.new(title: products(:ruby).title, description: "whatever", price: 1, image_url: "fred.gif" )
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test "product title must have minimum length" do
    product = Product.new(title: "1234", description: "whatever", price:1, image_url:"fred.jpg")
    assert product.invalid?
    assert product.errors[:title].any?
  end

  test "product title minimum length has a custom error message" do
    product = Product.new(title: "1", description: "whatever", price:1, image_url:"fred.jpg")
    assert product.invalid?
    assert product.errors[:title].any?
    assert_equal ['must be at least 5 characters!'], product.errors[:title]
  end
end
