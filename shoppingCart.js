// --- 1. 初始化資料 (跨頁同步) ---
let cart = JSON.parse(localStorage.getItem('myCart')) || [];

document.addEventListener('DOMContentLoaded', () => {
    updateCartUI(); // 頁面載入時同步畫面
    initReveal();   // 初始化原本的捲動動畫

    // --- 2. 監聽全站點擊事件 ---
    document.addEventListener('click', function (e) {
        // 判斷是否點擊了「加號」按鈕 (首頁的 .fa-plus 或 分頁的 .add-btn)
        if (e.target.classList.contains('fa-plus') || e.target.classList.contains('add-btn')) {
            const btn = e.target;
            let name, priceTxt;

            if (btn.classList.contains('add-btn')) {
                // 【2X4資料夾內的分頁結構】
                const productItem = btn.closest('.product-item');
                name = productItem.querySelector('.prod-tag-name').innerText;
                priceTxt = productItem.querySelector('.prod-price').innerText;
            } else {
                // 【根目錄首頁結構】
                const itemInfo = btn.closest('.item-info');
                if (itemInfo) {
                    name = itemInfo.querySelector('.tag').innerText;
                    priceTxt = itemInfo.querySelector('.price').innerText;
                }
            }

            if (name && priceTxt) {
                addToCart(name, priceTxt);
                // 按鈕縮放小動畫
                btn.style.transition = "transform 0.2s";
                btn.style.transform = "scale(1.4)";
                setTimeout(() => btn.style.transform = "scale(1)", 200);
            }
        }
    });
});

// --- 3. 核心功能函數 ---

function addToCart(name, priceTxt) {
    // 價格處理
    const price = parseInt(priceTxt.toString().replace(/[^0-9]/g, '')) || 0;
    
    // 存入陣列並更新 LocalStorage
    cart.push({ id: Date.now(), name: name, price: price });
    localStorage.setItem('myCart', JSON.stringify(cart));
    
    updateCartUI();
    
    // 【關鍵修改】加入後直接開啟側邊欄
    openCartSidebar(); 
}

// 強制開啟側邊欄
function openCartSidebar() {
    const sidebar = document.getElementById('cartSidebar');
    const overlay = document.getElementById('cartOverlay');
    if (sidebar) sidebar.classList.add('active');
    if (overlay) overlay.style.display = 'block';
}

// 原本的開關切換 (供導覽列圖示使用)
function toggleCart() {
    const sidebar = document.getElementById('cartSidebar');
    const overlay = document.getElementById('cartOverlay');
    if (sidebar) {
        const isActive = sidebar.classList.toggle('active');
        if (overlay) overlay.style.display = isActive ? 'block' : 'none';
    }
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

function removeItem(index) {
    cart.splice(index, 1);
    localStorage.setItem('myCart', JSON.stringify(cart));
    updateCartUI();
}

// --- 4. 捲動揭幕動畫 ---
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