class StoreController < ApplicationController
  include StoreIndexCounter
  before_action :increment_counter, only: [:index]

  def index
    @products = Product.order(:title)
    @store_counter = session[:store_counter]
  end
end
