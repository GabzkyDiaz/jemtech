class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:filter] == 'on_sale'
      @products = @products.on_sale
    elsif params[:filter] == 'recently_updated'
      @products = @products.recently_updated
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
