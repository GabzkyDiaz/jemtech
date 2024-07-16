module CartsHelper
  def truncated_product_name(product_name, length = 20)
    product_name.length > length ? "#{product_name[0, length]}..." : product_name
  end
end
