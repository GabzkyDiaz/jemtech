class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all

    if params[:filter] == 'on_sale'
      @products = @products.on_sale
    elsif params[:category]
      @products = @products.where(category_id: params[:category])
    end

    @products = @products.order(created_at: :desc) if params[:sort] == 'latest'
    @products = @products.order(name: :asc) if params[:sort] == 'a-z'

    @products = @products.page(params[:page]).per(12) # Pagination
  end

  def show
    @product = Product.find(params[:id])
  end
end
