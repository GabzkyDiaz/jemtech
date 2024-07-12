class PagesController < ApplicationController
  before_action :set_categories, only: [:home]
  before_action :set_page, only: [:about, :contact]

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

  def set_page
    @page = StaticPage.find_by(title: action_name.titleize + ' Us')
  end
end
