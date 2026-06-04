// utils/cart/main.js
/**
 * 功能：SQL 資料驅動版購物車核心
 * 說明：適應無 CartID、以 MemberID & ProductID 為複合主鍵之 cart 資料表
 */

let cart = [];

document.addEventListener('DOMContentLoaded', () => {
    loadCartFromDB();

    const checkoutBtn = document.querySelector('#cartSidebar .checkout-btn');
    if (checkoutBtn) {
        checkoutBtn.onclick = function () {
            if (cart.length === 0) {
                alert("購物車是空的喔！✿");
                return;
            }
            const root = getMappingPath().rootLayer;
            window.location.href = root + 'payment/index.jsp';
        };
    }
});

function getMappingPath() {
    const path = window.location.pathname;
    let apiPath = "utils/cart/";
    let rootLayer = "./";

    if (path.includes('/product/') || path.includes('/series/') || path.includes('/member/') || path.includes('/wishlist/') || path.includes('/payment/')) {
        apiPath = "../utils/cart/";
        rootLayer = "../";
    }
    return { apiPath, rootLayer };
}

/**
 * 1. 從資料庫讀取購物車 (連動 get_cart.jsp)
 */
function loadCartFromDB() {
    const { apiPath } = getMappingPath();

    fetch(`${apiPath}get_cart.jsp`)
        .then(res => res.json())
        .then(data => {
            cart = data;
            updateCartUI();
        })
        .catch(err => {
            console.error("無法自資料庫載入購物車項目:", err);
            cart = [];
            updateCartUI();
        });
}

/**
 * 2. 新增商品到購物車 (連動 add_to_cart.jsp)
 */
function addToCart(productId, qty = 1) {
    const { apiPath } = getMappingPath();

    if (!productId || productId === "undefined" || productId === "null") {
        alert("【前端錯誤】傳遞的 ProductID 無效！傳入值為: " + productId);
        return;
    }

    fetch(`${apiPath}add_to_cart.jsp?product_id=${productId}&qty=${qty}`)
        .then(res => res.text())
        .then(result => {
            const res = result.trim();
            if (res === 'success') {
                loadCartFromDB();
                toggleCart(true);
            } else if (res === 'nologin') {
                alert("請先登入會員，才能使用購物車功能功能喔！✿");
                const { rootLayer } = getMappingPath();
                window.location.href = rootLayer + "member/login/index.jsp";
            } else {
                alert("【後端錯誤】加入購物車失敗！\n後端回傳訊息：" + res);
            }
        })
        .catch(err => {
            console.error("購物車新增 Fetch 錯誤:", err);
            alert("網路請求失敗，請檢查主機連線。");
        });
}

/**
 * 3. 從購物車刪除商品 (改為傳遞 productId)
 */
function removeFromCart(productId) {
    const { apiPath } = getMappingPath();

    fetch(`${apiPath}remove_from_cart.jsp?product_id=${productId}`)
        .then(res => res.text())
        .then(result => {
            if (result.trim() === 'success') {
                loadCartFromDB();
            } else {
                alert("刪除商品失敗，錯誤原因：" + result.trim());
            }
        })
        .catch(err => console.error("購物車刪除錯誤:", err));
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

    if (cart.length === 0) {
        list.innerHTML = '<p style="text-align:center; padding:30px; color:#999; font-family:\'Noto Serif TC\', serif;">購物車是空的 ✿</p>';
        totalSpan.innerText = "0";
        return;
    }

    list.innerHTML = '';
    let total = 0;

    cart.forEach((item) => {
        // 注意：這裡的數量欄位與 SQL 一致的 Quantity
        const itemTotal = item.Price * item.Quantity;
        total += itemTotal;

        list.innerHTML += `
            <div class="cart-item">
                <div class="item-info">
                    <div class="item-name" title="${item.ProductName}">${item.ProductName}</div>
                    <div class="item-meta">
                        NT$ ${item.Price.toLocaleString()} &times; ${item.Quantity}
                    </div>
                </div>
                <div class="item-price-action">
                    <span class="item-price">NT$ ${itemTotal.toLocaleString()}</span>
                    <i class="fa-solid fa-trash delete-icon" onclick="removeFromCart(${item.ProductID})" title="移除商品"></i>
                </div>
            </div>
        `;
    });

    totalSpan.innerText = total.toLocaleString();
}