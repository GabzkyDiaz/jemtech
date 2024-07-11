class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all

    # Apply filters
    if params[:filter] == 'on_sale'
      on_sale_tag = Tag.find_by(name: 'on_sale')
      @products = @products.joins(:tags).where(tags: { id: on_sale_tag.id }) if on_sale_tag
    end

    if params[:categories].present?
      category_ids = params[:categories].split(',')
      @products = @products.where(category_id: category_ids)
    end

    if params[:category].present?
      category = Category.find_by(name: params[:category])
      @products = @products.where(category_id: category.id) if category
    end

    if params[:updated] == 'recently_updated'
      @products = @products.where('products.updated_at >= ?', 3.days.ago)
    end

    # Apply sorting
    case params[:sort]
    when 'latest'
      @products = @products.order(created_at: :desc)
    when 'a-z'
      @products = @products.order(name: :asc)
    else
      @products = @products.order('products.updated_at DESC') if params[:updated] == 'recently_updated'
    end

    @products = @products.page(params[:page]).per(12) # Pagination
  end

  def show
    @product = Product.find(params[:id])
  end
end
