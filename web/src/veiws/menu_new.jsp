<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>CafeFlow Menu</title>
<link rel="stylesheet" href="../css/menu_css.css">
<link rel="stylesheet" href="../css/style.css">
<style>
    /* simple green check style */
    .added-check { color: #28a745; font-weight: bold; margin-left: 8px; opacity: 0; transition: opacity 0.2s ease-in-out; }
    .added-check.visible { opacity: 1; }

    /* ── OVERRIDES ── */
    .menu-category { 
        width: 100%;
        clear: both; /* Ensures each category appears on its own line */
        margin-bottom: 30px; /* Add some space between categories */
    }
    .menu-category > h2.section { 
        text-align: left !important; 
        margin-bottom: 15px;
        padding: 8px 25px; /* Add padding around the text */
        background-color: #6a0dad; /* Purple background */
        color: white; /* White text */
        border-radius: 8px; /* Slightly rounded corners */
    }
    .menu-category .cards { 
        display: flex !important; 
        flex-wrap: wrap; 
        justify-content: flex-start !important; 
        gap: 20px; /* Add consistent gap between cards */
        padding-left: 10px;
    }
    .quantity-controls button { margin: 0 8px !important; }

    /* Product card styling */
    .product-card {
        width: 250px; /* Fixed width for consistent cards */
        margin-right: 0; /* Remove any right margin */
    }

    /* Floating cart button */
    .floating-cart {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #28a745;
        color: #fff;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        cursor: pointer;
        z-index: 1000;
    }

    .floating-cart:hover { background: #218838; }
</style>
</head>
<body>
  <div class="container">
    <jsp:include page="../jsp/header.jsp" />
    <main>
      <h1 style="text-align:center; margin-top: 20px;">Our Delicious Menu</h1>
      <div class="menu-section" id="menu-container" aria-live="polite"></div>
    </main>
  </div>

  <!-- Floating Cart Button -->
  <div class="floating-cart" onclick="window.location.href='cart_new.jsp'" title="View Cart">
    🛒
  </div>
<script>
document.addEventListener("DOMContentLoaded", () => {
  fetchMenuItems();
});

function fetchMenuItems() {
  const url = '<%= request.getContextPath() %>/api/menu';
  fetch(url)
    .then(res => {
      if (!res.ok) throw new Error(res.statusText);
      return res.json();
    })
    .then(data => renderMenu(data))
    .catch(_ => {
      document.getElementById('menu-container').innerHTML =
        '<p style="color:red; text-align:center;">❌ Error loading menu.</p>';
    });
}

function renderMenu(items) {
  const grouped = items.reduce((acc, item) => {
    const cat = item.category || 'Uncategorized';
    (acc[cat] = acc[cat]||[]).push(item);
    return acc;
  }, {});

  const container = document.getElementById('menu-container');
  container.innerHTML = '';

  for (const category in grouped) {
    const section = document.createElement('section');
    section.className = 'menu-category';
    section.setAttribute('aria-label', category);

    const h2 = document.createElement('h2');
    h2.className = 'section h2';
    h2.textContent = category;
    section.appendChild(h2);

    const grid = document.createElement('div');
    grid.className = 'cards';

    grouped[category].forEach(item => {
      if (!item.name || item.price == null) return;

      const unitPrice = parseFloat(
        String(item.price).replace(/,/g, '.').replace(/[^0-9.]/g, '')
      );
      if (isNaN(unitPrice)) return;
      const formattedPrice = unitPrice.toFixed(2);

      const card = document.createElement('div');
      card.className = 'product-card';
      card.dataset.unitPrice = unitPrice;

      // image frame
      const imgF = document.createElement('div');
      imgF.className = 'image-frame';
      const img = document.createElement('img');
      img.src = '<%= request.getContextPath() %>/' + item.imagePath;

      console.log(img.src);
      img.alt = item.name;
      imgF.appendChild(img);

      // name + desc
      const nameEl = document.createElement('h3');
      nameEl.textContent = item.name;
      const desc = document.createElement('p');
      desc.className = 'description';
      desc.textContent = item.description || '';

      // price
      const priceEl = document.createElement('p');
      priceEl.className = 'price';
      priceEl.textContent = 'Rs. ' + formattedPrice;

      // qty controls
      const qtyCtl = document.createElement('div');
      qtyCtl.className = 'quantity-controls';
      const dec = document.createElement('button');
      dec.type = 'button';
      dec.textContent = '-';
      const qtySpan = document.createElement('span');
      qtySpan.textContent = '0';
      const inc = document.createElement('button');
      inc.type = 'button';
      inc.textContent = '+';

      function updatePrice(q) {
        priceEl.textContent = 'Rs. ' + (unitPrice * q).toFixed(2);
      }
      inc.addEventListener('click', () => {
        let q = +qtySpan.textContent + 1;
        qtySpan.textContent = q;
        updatePrice(q);
      });
      dec.addEventListener('click', () => {
        let q = Math.max(0, +qtySpan.textContent - 1);
        qtySpan.textContent = q;
        updatePrice(q);
      });
      qtyCtl.append(dec, qtySpan, inc);

      // Add to Cart button & checkmark
      const addBtn = document.createElement('button');
      addBtn.type = 'button';
      addBtn.className = 'add-to-cart';
      addBtn.textContent = 'Add to Cart 🛒';

      // create the green✓ but don't attach yet
      const check = document.createElement('span');
      check.className = 'added-check';
      check.textContent = '✓';

      addBtn.addEventListener('click', () => {
        const q = +qtySpan.textContent;
        if (q < 1) {
          return alert('❗ Please select quantity before adding to cart.');
        }
        const name = nameEl.textContent;
        const unit = parseFloat(card.dataset.unitPrice);
        const cart = JSON.parse(localStorage.getItem('cart') || '[]');
        const existing = cart.find(i => i.name === name);
        if (existing) existing.quantity += q;
        else cart.push({ name, price: unit, quantity: q });
        localStorage.setItem('cart', JSON.stringify(cart));

        if (!check.isConnected) {
          addBtn.parentNode.insertBefore(check, addBtn.nextSibling);
        }
        check.classList.add('visible');
        setTimeout(() => check.classList.remove('visible'), 1000);
      });

      // assemble
      card.append(imgF, nameEl, desc, priceEl, qtyCtl, addBtn);
      grid.appendChild(card);
    });

    section.appendChild(grid);
    container.appendChild(section);
  }
}
</script>
  <jsp:include page="../jsp/footer.jsp" />

</body>
</html>
