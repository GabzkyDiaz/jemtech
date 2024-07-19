# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Calculate the total number of orders and total amount for orders with status 'paid' and 'shipped'
    total_orders = Order.where(status: ['paid', 'shipped']).count
    total_amount = Order.where(status: ['paid', 'shipped']).sum(:total_amount)

    # Display the calculated totals at the top of the dashboard
    panel "Order Statistics" do
      div do
        h3 "Total Number of Orders: #{total_orders}"
      end
      div do
        h3 "Total Amount from Orders: #{number_to_currency(total_amount)}"
      end
    end

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "All Past Orders" do
          table_for Order.order('created_at desc') do
            column("Order ID") { |order| link_to order.id, admin_order_path(order) }
            column("Customer Email") { |order| order.customer.email }
            column("Customer Name") { |order| "#{order.customer.first_name} #{order.customer.last_name}" }
            column("Date", :order_date)
            column("Status", :status)
            column("Total Amount") { |order| number_to_currency order.total_amount }
            column("Products Ordered") do |order|
              ul do
                order.order_items.each do |item|
                  li "#{item.product.name} (x#{item.quantity})"
                end
              end
            end
            column("Taxes") do |order|
              ul do
                li "GST: #{number_to_currency(order.gst_amount)}"
                li "PST: #{number_to_currency(order.pst_amount)}"
                li "HST: #{number_to_currency(order.hst_amount)}"
                li "QST: #{number_to_currency(order.qst_amount)}"
              end
            end
            column("Grand Total") { |order| number_to_currency(order.total_amount) }
          end
          strong { link_to "View All Orders", admin_orders_path }
        end
      end
    end
  end # content
end
