class PagesController < ApplicationController
  before_action :set_categories, only: [:home, :about, :contact]

  def home
  end

  def about
  end

  def contact
  end

  private

  def set_categories
    @categories = Category.all
  end
end
