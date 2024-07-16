document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.add-to-cart-button').forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();
      var productId = this.getAttribute('data-product-id');
      var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      fetch('/cart/add_item', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ product_id: productId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('Item added to cart successfully');
          updateCartButton(data.cart_count);
          fetchCartContents();
        } else {
          alert('There was an error adding the item to the cart.');
        }
      });
    });
  });

  document.querySelectorAll('.remove-item-button').forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();
      var productId = this.getAttribute('data-product-id');
      var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      fetch('/cart/remove_item', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ product_id: productId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('Item removed from cart successfully');
          location.reload(); // Reload the page to update the cart items
        } else {
          alert('There was an error removing the item from the cart.');
        }
      });
    });
  });

  document.querySelectorAll('.update-quantity-button').forEach(function (button) {
    button.addEventListener('click', function (e) {
      e.preventDefault();
      var productId = this.getAttribute('data-product-id');
      var quantity = this.parentElement.querySelector('.quantity-input').value;
      var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      fetch('/cart/update_item', {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ product_id: productId, quantity: quantity })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('Quantity updated successfully');
          location.reload(); // Reload the page to update the cart items
        } else {
          alert('There was an error updating the quantity.');
        }
      });
    });
  });

  document.getElementById('empty-cart-button').addEventListener('click', function (e) {
    e.preventDefault();
    var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    fetch('/cart/empty_cart', {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('Cart emptied successfully');
        location.reload(); // Reload the page to update the cart items
      } else {
        alert('There was an error emptying the cart.');
      }
    });
  });

  document.getElementById('cart-button').addEventListener('mouseenter', function() {
    var cartDropdown = document.getElementById('cart-dropdown');
    cartDropdown.classList.remove('hidden');
    fetchCartContents();
  });

  document.getElementById('cart-button').addEventListener('mouseleave', function() {
    var cartDropdown = document.getElementById('cart-dropdown');
    cartDropdown.classList.add('hidden');
  });

  function updateCartButton(cartCount) {
    var cartButton = document.getElementById('cart-button');
    cartButton.textContent = `Cart (${cartCount})`;
  }

  function fetchCartContents() {
    fetch('/cart')
      .then(response => response.text())
      .then(html => {
        document.getElementById('cart-dropdown').innerHTML = html;
      });
  }
});
