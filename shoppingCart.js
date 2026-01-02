// --- 1. 初始化資料 (跨頁同步) ---
let cart = JSON.parse(localStorage.getItem('myCart')) || [];

document.addEventListener('DOMContentLoaded', () => {
    updateCartUI();
    initReveal();

    // --- 2. 監聽點擊事件 (用於處理靜態 HTML 裡的按鈕) ---
    document.addEventListener('click', function (e) {
        const isPlusIcon = e.target.classList.contains('fa-plus');
        const isAddBtn = e.target.classList.contains('add-btn');

        if (isPlusIcon || isAddBtn) {
            // 檢查是否已經由 onclick 處理過了
            const parentBtn = e.target.closest('button');
            if (parentBtn && parentBtn.hasAttribute('onclick')) return;

            let name, priceTxt;
            // 處理非動態生成的產品（例如手寫在 HTML 裡的）
            const itemInfo = e.target.closest('.item-info');
            if (itemInfo) {
                name = itemInfo.querySelector('.tag')?.innerText;
                priceTxt = itemInfo.querySelector('.price')?.innerText;
                if (name && priceTxt) addToCart(name, priceTxt);
            }
        }
    });
});

// --- 3. 核心功能函數 ---

// 統一接收名稱與價格
function addToCart(name, priceInput) {
    let price = 0;
    // 自動判斷傳入的是數字還是字串
    if (typeof priceInput === 'number') {
        price = priceInput;
    } else if (typeof priceInput === 'string') {
        price = parseInt(priceInput.replace(/[^0-9]/g, '')) || 0;
    }

    cart.push({ id: Date.now(), name: name, price: price });
    localStorage.setItem('myCart', JSON.stringify(cart));

    updateCartUI();
    openCartSidebar();
}

function updateCartUI() {
    const list = document.getElementById('cartItems');
    const totalSpan = document.getElementById('cartTotal');
    if (!list || !totalSpan) return;

    list.innerHTML = '';
    let total = 0;

    if (cart.length === 0) {
        list.innerHTML = '<p style="text-align:center; padding:30px; color:#999;">購物車是空的</p>';
    } else {
        cart.forEach((item, index) => {
            total += item.price;
            list.innerHTML += `
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; padding-bottom:10px; border-bottom:1px solid #ddd;">
                    <div style="flex:1;">
                        <div style="font-weight:bold; color:#705844;">${item.name}</div>
                        <div style="font-size:0.8rem; color:#888;">NT$ ${item.price.toLocaleString()}</div>
                    </div>
                    <i class="fa-solid fa-trash" style="cursor:pointer; color:#A3A69C; padding:5px;" onclick="removeItem(${index})"></i>
                </div>`;
        });
    }
    totalSpan.innerText = total.toLocaleString();
}

function toggleCart() {
    const sidebar = document.getElementById('cartSidebar');
    const overlay = document.getElementById('cartOverlay');
    if (sidebar) {
        const isActive = sidebar.classList.toggle('active');
        if (overlay) overlay.style.display = isActive ? 'block' : 'none';
    }
}
function openCartSidebar() {
    const sidebar = document.getElementById('cartSidebar');
    const overlay = document.getElementById('cartOverlay');
    if (sidebar) sidebar.classList.add('active');
    if (overlay) overlay.style.display = 'block';
}
function removeItem(index) {
    cart.splice(index, 1);
    localStorage.setItem('myCart', JSON.stringify(cart));
    updateCartUI();
}
function initReveal() {
    const revealElements = document.querySelectorAll('.collection, .quiz-intro, .contact-top');
    revealElements.forEach(el => {
        el.style.opacity = "0";
        el.style.transform = "translateY(30px)";
        el.style.transition = "all 0.8s ease-out";
    });
    window.addEventListener('scroll', () => {
        revealElements.forEach(el => {
            const windowHeight = window.innerHeight;
            const revealTop = el.getBoundingClientRect().top;
            if (revealTop < windowHeight - 100) {
                el.style.opacity = "1";
                el.style.transform = "translateY(0)";
            }
        });
    });
}