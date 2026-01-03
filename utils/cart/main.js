// utils/cart/main.js
let cart = JSON.parse(localStorage.getItem('myCart')) || [];

document.addEventListener('DOMContentLoaded', () => {
    updateCartUI();

    const checkoutBtn = document.querySelector('#cartSidebar .checkout-btn');
    if (checkoutBtn) {
        checkoutBtn.onclick = function() {
            if (cart.length === 0) {
                alert("購物車是空的喔！");
                return;
            }
            // 從 product 頁面跳轉到 payment 頁面
            window.location.href = '../payment/index.html';
        };
    }
});

function addToCart(name, priceValue) {
    const price = typeof priceValue === 'number' ? priceValue : parseInt(priceValue.replace(/[^0-9]/g, '')) || 0;
    cart.push({ id: Date.now(), name: name, price: price });
    localStorage.setItem('myCart', JSON.stringify(cart));
    
    updateCartUI();
    toggleCart(true); // 開啟側邊欄
}

function toggleCart(forceOpen = false) {
    const sidebar = document.getElementById('cartSidebar');
    const overlay = document.getElementById('cartOverlay');
    if (!sidebar) return;

    if (forceOpen === true) {
        sidebar.classList.add('active');
        if (overlay) overlay.style.display = 'block';
    } else {
        const isActive = sidebar.classList.toggle('active');
        if (overlay) overlay.style.display = isActive ? 'block' : 'none';
    }
}

function updateCartUI() {
    const list = document.getElementById('cartItems');
    const totalSpan = document.getElementById('cartTotal');
    if (!list || !totalSpan) return;

    list.innerHTML = cart.length === 0 
        ? '<p style="text-align:center; padding:30px; color:#999;">購物車是空的</p>' 
        : '';

    let total = 0;
    cart.forEach((item, index) => {
        total += item.price;
        list.innerHTML += `
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; padding-bottom:10px; border-bottom:1px solid #eee;">
                <div>
                    <div style="font-weight:bold; color:#705844;">${item.name}</div>
                    <div style="font-size:0.8rem; color:#888;">NT$ ${item.price.toLocaleString()}</div>
                </div>
                <i class="fa-solid fa-trash" style="cursor:pointer; color:#A3A69C;" onclick="removeItem(${index})"></i>
            </div>`;
    });
    totalSpan.innerText = total.toLocaleString();
}

function removeItem(index) {
    cart.splice(index, 1);
    localStorage.setItem('myCart', JSON.stringify(cart));
    updateCartUI();
}