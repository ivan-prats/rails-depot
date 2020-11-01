class LineItemsController < ApplicationController
  include CurrentCart
  include StoreIndexCounter
  before_action :set_cart, only: %i[create show edit update destroy]
  before_action :reset_counter, only: [:create]
  before_action :set_line_item, only: %i[show edit update destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show; end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit; end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url, notice: 'Line item was successfully added.', flash: { notice_type: 'success' } }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.js { redirect_to store_index_url, notice: "The item couldn't be added: #{@line_item.errors.full_messages}", flash: { notice_type: 'error' } }
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    if @line_item.update(line_item_params)
      if @line_item.quantity < 1
        @line_item.destroy
        line_item_respond_to('destroy')
      else
        line_item_respond_to('update', true)
      end
    else
      line_item_respond_to('update', false)
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    line_item_respond_to('destroy')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
    if @line_item.cart_id == @cart.id
      @line_item
    else
      redirect_to store_index_url, notice: 'There was an error loading the Item', flash: { notice_type: 'error' }
    end
  end

  def line_item_respond_to(method, is_success = true)
    case method
    when 'update'
      if is_success
        respond_to do |format|
          format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
          format.json { render :show, status: :ok, location: @line_item }
          format.js { @current_item = @line_item }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end

    when 'destroy'
      respond_to do |format|
        format.html { redirect_to @cart, notice: 'Line item was successfully deleted', flash: { notice_type: 'success' } }
        format.json { head :no_content }
        format.js
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end
end
