class ProductsController < ApplicationController
  before_action :set_categories, only: [:index, :show, :search]

  def index
    @products = Product.all

    # Apply filters
    if params[:filter] == 'on_sale'
      on_sale_tag = Tag.find_by(name: 'on_sale')
      @products = @products.joins(:tags).where(tags: { id: on_sale_tag.id }) if on_sale_tag
    end

    if params[:categories].present?
      category_ids = params[:categories].split(',')
      @products = @products.joins(:tags).where(tags: { id: category_ids })
    end

    if params[:category].present?
      category_tag = Tag.find_by(name: params[:category])
      @products = @products.joins(:tags).where(tags: { id: category_tag.id }) if category_tag
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

  def search
    @category_tag = Tag.find_by(id: params[:category]) if params[:category].present?
    @products = if @category_tag
                  Product.joins(:tags).where(tags: { id: @category_tag.id }).where("products.name LIKE ? OR products.description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
                else
                  Product.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
                end
    @products = @products.page(params[:page]).per(12)
    render :index
  end

  private

  def set_categories
    @categories = Category.all
  end
end
