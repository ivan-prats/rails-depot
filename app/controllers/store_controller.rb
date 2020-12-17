class StoreController < ApplicationController
  include StoreIndexCounter
  before_action :increment_counter, only: [:index]

  skip_before_action :authorize

  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.all.order(:title)
    @store_counter = session[:store_counter]
  end
end
