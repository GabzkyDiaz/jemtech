document.addEventListener('DOMContentLoaded', function () {
  // Initialize Swiper
  if (typeof Swiper !== 'undefined') {
    var swiper = new Swiper('.swiper-container', {
      slidesPerView: 1,
      loop: true,
      autoplay: {
        delay: 5000,
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      breakpoints: {
        640: {
          slidesPerView: 1,
          spaceBetween: 10,
        },
        768: {
          slidesPerView: 2,
          spaceBetween: 20,
        },
        1024: {
          slidesPerView: 3,
          spaceBetween: 30,
        },
      },
    });
  }

  // Add to cart functionality
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

  // Remove from cart functionality
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

  // Update quantity functionality
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

  // Empty cart functionality
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

  // Cart button hover functionality
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

  // Cart hover functionality for another cart element
  const cartIcon = document.querySelector('.cart-wrapper');
  const cartDropdown = cartIcon.querySelector('.group-hover\\:block');

  cartIcon.addEventListener('mouseenter', function () {
    clearTimeout(cartIcon.__timer);
    cartDropdown.classList.remove('hidden');
  });

  cartIcon.addEventListener('mouseleave', function () {
    cartIcon.__timer = setTimeout(() => {
      cartDropdown.classList.add('hidden');
    }, 1300);
  });

  cartDropdown.addEventListener('mouseenter', function () {
    clearTimeout(cartIcon.__timer);
  });

  cartDropdown.addEventListener('mouseleave', function () {
    cartIcon.__timer = setTimeout(() => {
      cartDropdown.classList.add('hidden');
    }, 1300);
  });

  // Mobile menu functionality
  const hamburgerBtn = document.getElementById('hamburger');
  const mobileMenu = document.querySelector('.mobile-menu');

  hamburgerBtn.addEventListener('click', function () {
    mobileMenu.classList.toggle('hidden');
  });

  // Search icon functionality
  document.getElementById('search-icon').addEventListener('click', function() {
    var searchField = document.getElementById('search-field');
    if (searchField.classList.contains('hidden')) {
      searchField.classList.remove('hidden');
      searchField.classList.add('search-slide-down');
    } else {
      searchField.classList.add('hidden');
      searchField.classList.remove('search-slide-down');
    }
  });

  // Dropdown toggle functionality
  function toggleDropdown(id, show) {
    const dropdown = document.getElementById(id);
    if (show) {
      dropdown.classList.remove('hidden');
    } else {
      dropdown.classList.add('hidden');
    }
  }

  // Change main image functionality
  function changeImage(element) {
    var mainImage = document.getElementById('main-image');
    mainImage.src = element.getAttribute('data-full');
  }

  // Single page product count functionality
  const decreaseButton = document.getElementById('decrease');
  const increaseButton = document.getElementById('increase');
  const quantityInput = document.getElementById('quantity');

  if (decreaseButton && increaseButton && quantityInput) {
    decreaseButton.addEventListener('click', function () {
      let quantity = parseInt(quantityInput.value);
      if (quantity > 1) {
        quantity -= 1;
        quantityInput.value = quantity;
      }
      updateButtons();
    });

    increaseButton.addEventListener('click', function () {
      let quantity = parseInt(quantityInput.value);
      quantity += 1;
      quantityInput.value = quantity;
      updateButtons();
    });

    function updateButtons() {
      if (parseInt(quantityInput.value) === 1) {
        decreaseButton.setAttribute('disabled', true);
      } else {
        decreaseButton.removeAttribute('disabled');
      }
    }
  }

  // Single product tabs functionality
  const tabs = document.querySelectorAll('.tab');
  const contents = document.querySelectorAll('.tab-content');

  if (tabs.length > 0 && contents.length > 0) {
    tabs.forEach(tab => {
      tab.addEventListener('click', function () {
        tabs.forEach(t => {
          t.classList.remove('active');
          t.setAttribute('aria-selected', 'false');
        });
        contents.forEach(c => c.classList.add('hidden'));

        this.classList.add('active');
        this.setAttribute('aria-selected', 'true');
        document.querySelector(`#${this.id.replace('-tab', '-content')}`).classList.remove('hidden');
      });
    });

    tabs[0].click();
  }

  // Shop page filter show/hide functionality
  const toggleButton = document.getElementById('products-toggle-filters');
  const filters = document.getElementById('filters');

  if (toggleButton && filters) {
    toggleButton.addEventListener('click', function() {
      if (filters.classList.contains('hidden')) {
        filters.classList.remove('hidden');
        this.textContent = 'Hide Filters';
      } else {
        filters.classList.add('hidden');
        this.textContent = 'Show Filters';
      }
    });
  }

  // Shop page filter arrow toggle functionality
  const selectElement = document.querySelector('select');
  const arrowDown = document.getElementById('arrow-down');
  const arrowUp = document.getElementById('arrow-up');

  if (selectElement && arrowDown && arrowUp) {
    selectElement.addEventListener('click', function () {
      arrowDown.classList.toggle('hidden');
      arrowUp.classList.toggle('hidden');
    });
  }

  // Cart page increment/decrement functionality
  document.querySelectorAll('.cart-increment').forEach(button => {
    button.addEventListener('click', function () {
      let quantityElement = this.previousElementSibling;
      let quantity = parseInt(quantityElement.textContent, 10);
      quantityElement.textContent = quantity + 1;
    });
  });

  document.querySelectorAll('.cart-decrement').forEach(button => {
    button.addEventListener('click', function () {
      let quantityElement = this.nextElementSibling;
      let quantity = parseInt(quantityElement.textContent, 10);
      if (quantity > 1) {
        quantityElement.textContent = quantity - 1;
      }
    });
  });
});
