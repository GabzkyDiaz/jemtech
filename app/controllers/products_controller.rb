class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all

    if params[:filter] == 'on_sale'
      on_sale_tag = Tag.find_by(name: 'on_sale')
      @products = @products.joins(:tags).where(tags: { id: on_sale_tag.id }) if on_sale_tag
    elsif params[:categories].present?
      category_ids = params[:categories].split(',')
      @products = @products.where(category_id: category_ids)
    end

    @products = @products.order(created_at: :desc) if params[:sort] == 'latest'
    @products = @products.order(name: :asc) if params[:sort] == 'a-z'

    @products = @products.page(params[:page]).per(12) # Pagination
  end

  def show
    @product = Product.find(params[:id])
  end
end
