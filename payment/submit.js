/**
 * payment/submit.js
 * 功能：結帳頁面控制器 - SQL 資料庫對接版 (新增自動填寫會員資料功能)
 * 說明：即時載入會員 SQL 購物車內容，載入時自動取得並填入會員資料，支援一鍵建立訂單與完整防錯驗證
 */

let checkoutCart = []; // 儲存自 get_checkout_cart.jsp 載入的項目

document.addEventListener('DOMContentLoaded', () => {
    renderCheckout();
    autoFillMemberInfo();
    autoFillDate();
});

function autoFillDate() {
    const dateInput = document.getElementById("order-date");

    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');

    const formattedToday = `${year}-${month}-${day}`;
    dateInput.value = formattedToday;
    dateInput.min = formattedToday;
}

/**
 * 自動獲取並填寫會員資料 (Name & Phone)
 */
async function autoFillMemberInfo() {
    const nameInput = document.getElementById('order-name');
    const phoneInput = document.getElementById('order-phone');
    const addressInput = document.getElementById('order-address');

    if (!nameInput || !phoneInput || !addressInput) return;

    try {
        const response = await fetch('get_member_info.jsp');
        const result = await response.json();

        if (result.status === 'success') {
            // 💡 若成功獲取資料，自動填入對應的欄位中
            nameInput.value = result.name || "";
            phoneInput.value = result.phone || "";
            addressInput.value = result.address || "";
        } else if (result.status === 'nologin') {
            console.log("使用者未登入或 Session 已過期，不進行自動填寫。");
        }
    } catch (error) {
        console.error("無法自動獲取會員預填資訊:", error);
    }
}

/**
 * 1. 載入並渲染購物清單與總金額
 */
async function renderCheckout() {
    const productList = document.getElementById('checkout-product-list');
    const listSubtotal = document.getElementById('list-subtotal'); // 購物清單下方小計
    const subtotalDisplay = document.getElementById('subtotal-val'); // 訂單資訊商品總額
    const totalDisplay = document.getElementById('total-val');       // 最終總額

    if (!productList) return;

    try {
        const response = await fetch('get_checkout_cart.jsp');
        checkoutCart = await response.json();

        if (checkoutCart.length === 0) {
            productList.innerHTML = '<p style="text-align:center; padding:50px; color:#999; font-family:\'Noto Serif TC\', serif;">購物車內目前沒有商品 ✿</p>';
            if (listSubtotal) listSubtotal.innerText = `NT$ 0`;
            if (subtotalDisplay) subtotalDisplay.innerText = `NT$ 0`;
            if (totalDisplay) totalDisplay.innerText = `NT$ 0`;
            return;
        }

        productList.innerHTML = '';
        let total = 0;

        checkoutCart.forEach(item => {
            const itemTotal = item.Price * item.Quantity;
            total += itemTotal;

            // 動態組裝出與商品路徑對應的 relativeIndex 第一張縮圖
            const imagePath = `../image/flower/${item.Category}/${item.relativeIndex}-1.jpg`;

            productList.innerHTML += `
                <div class="product-item" style="font-family:'Noto Serif TC', serif;">
                    <div class="prod-img">
                        <img src="${imagePath}" alt="${item.ProductName}" onerror="this.src='../image/default.jpg'">
                    </div>
                    <div class="prod-details">
                        <p class="name">${item.ProductName}</p>
                        <p class="price">NT$ ${item.Price.toLocaleString()}</p>
                    </div>
                    <span class="quantity">X${item.Quantity}</span>
                </div>`;
        });

        // 更新各個區塊的價格標籤
        const formattedSubtotal = `NT$ ${total.toLocaleString()}`;
        const formattedTotal = `NT$ ${(total + 120).toLocaleString()}`; // 商品總額 + 120 運費

        if (listSubtotal) listSubtotal.innerText = formattedSubtotal;
        if (subtotalDisplay) subtotalDisplay.innerText = formattedSubtotal;
        if (totalDisplay) totalDisplay.innerText = formattedTotal;

    } catch (error) {
        console.error("無法載入結帳商品清單:", error);
        productList.innerHTML = '<p style="text-align:center; padding:50px; color:#f00; font-family:\'Noto Serif TC\', serif;">資料載入異常，請重新整理頁面。✿</p>';
    }
}

/**
 * 2. 提交訂單：連動資料庫交易寫入 (orders, order_detail)
 */
async function submitOrder() {
    if (checkoutCart.length === 0) {
        alert("您的購物車內沒有商品，無法送出訂單喔！✿");
        return;
    }

    const nameInput = document.getElementById('order-name');
    const phoneInput = document.getElementById('order-phone');
    const noteInput = document.getElementById('order-note');
    const dateInput = document.getElementById('order-date');
    const addressInput = document.getElementById('order-address');
    const paymentSelect = document.getElementById('order-payment');

    const name = nameInput ? nameInput.value.trim() : "";
    const phone = phoneInput ? phoneInput.value.trim() : "";
    const note = noteInput ? noteInput.value.trim() : "";
    const deliveryDate = dateInput ? dateInput.value.trim() : "";
    const address = addressInput ? addressInput.value.trim() : "";
    const paymentMethod = paymentSelect ? paymentSelect.value : "";

    // 顧客資料防呆驗證
    if (!name || !phone || !address || !paymentMethod) {
        alert("請完整填寫收件人姓名、電話、地址與付款方式！✿");
        return;
    }

    // 將資料打包成 QueryString 格式
    const params = new URLSearchParams();
    params.append('name', name);
    params.append('phone', phone);
    params.append('note', note);
    params.append('delivery_date', deliveryDate);
    params.append('address', address);
    params.append('payment_method', paymentMethod);

    try {
        const checkoutBtn = document.querySelector('.checkout-btn');
        if (checkoutBtn) checkoutBtn.disabled = true; // 防止重複點擊

        const response = await fetch('create_order.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
            },
            body: params.toString()
        });

        const result = await response.json();

        if (result.status === 'success') {
            // 訂單建立成功：顯示成功 Overlay 並且顯示漂亮的流水號！
            const overlay = document.getElementById('successOverlay');
            const displayId = document.getElementById('order-id-display');

            if (displayId) {
                displayId.innerText = result.order_number; // 顯示 ORD-2026xxxx 格式
            }

            if (overlay) {
                overlay.classList.add('active');
                // 點擊背景可將其關閉
                overlay.onclick = function (e) {
                    if (e.target === overlay) {
                        overlay.classList.remove('active');
                    }
                };
            }
        } else if (result.status === 'out_of_stock') {
            alert("結帳失敗：購物車中有商品庫存不足，請先調整購物車數量。✿");
            if (checkoutBtn) checkoutBtn.disabled = false;
        } else if (result.status === 'empty_cart') {
            alert("您的購物車內已經空無一物了喔！");
            if (checkoutBtn) checkoutBtn.disabled = false;
        } else if (result.status === 'nologin') {
            alert("登入狀態已過期，請重新登入！");
            window.location.href = "../member/login/index.jsp";
        } else {
            alert("建立訂單時遇到問題：" + (result.message || result.status));
            if (checkoutBtn) checkoutBtn.disabled = false;
        }

    } catch (error) {
        console.error("提交訂單時網路異常:", error);
        alert("伺服器連線失敗，請檢查您的網路狀態。");
        const checkoutBtn = document.querySelector('.checkout-btn');
        if (checkoutBtn) checkoutBtn.disabled = false;
    }
}