<%@ page contentType = "text/javascript;charset=utf-8" language = "java" %>

/**
 * payment/submit.js
 * 功能：結帳頁面控制器 - SQL 資料庫對接版
 * 新增：優惠券載入、活動折扣計算、送出訂單時傳送 coupon_id、當月壽星提示
 */

let checkoutCart = [];
let cartSubtotal = 0;
const SHIPPING_FEE = 120;

document.addEventListener('DOMContentLoaded', async () => {
    await renderCheckout();
    await loadCoupons();
    autoFillMemberInfo();
    autoFillDate();

    const couponSelect = document.getElementById('coupon-select');
    if (couponSelect) {
        couponSelect.addEventListener('change', updateSummary);
    }
});

function autoFillDate() {
    const dateInput = document.getElementById("order-date");
    if (!dateInput) return;

    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');

    const formattedToday = `\${year}-\${month}-\${day}`;
    dateInput.value = formattedToday;
    dateInput.min = formattedToday;
}

async function autoFillMemberInfo() {
    const nameInput = document.getElementById('order-name');
    const phoneInput = document.getElementById('order-phone');
    const addressInput = document.getElementById('order-address');

    if (!nameInput || !phoneInput || !addressInput) return;

    try {
        const response = await fetch('get_member_info.jsp');
        const result = await response.json();

        if (result.status === 'success') {
            nameInput.value = result.name || "";
            phoneInput.value = result.phone || "";
            addressInput.value = result.address || "";

            // 當月壽星贈品提示
            const birthday = result.birthday || result.Birthday || "";
            showBirthdayGift(birthday);

        } else if (result.status === 'nologin') {
            console.log("使用者未登入或 Session 已過期，不進行自動填寫。");
        }
    } catch (error) {
        console.error("無法自動獲取會員預填資訊:", error);
    }
}

function showBirthdayGift(birthday) {
    const giftBox = document.getElementById('birthday-gift-box');
    if (!giftBox || !birthday) return;

    const birthDate = new Date(birthday);
    if (isNaN(birthDate.getTime())) return;

    const birthMonth = birthDate.getMonth() + 1;
    const currentMonth = new Date().getMonth() + 1;

    if (birthMonth === currentMonth) {
        giftBox.innerHTML = `
            <div class="birthday-gift">
                🎁 本月壽星禮遇：贈送品牌提袋一份
            </div>
        `;
    } else {
        giftBox.innerHTML = "";
    }
}

async function renderCheckout() {
    const productList = document.getElementById('checkout-product-list');
    const listSubtotal = document.getElementById('list-subtotal');

    if (!productList) return;

    try {
        const response = await fetch('get_checkout_cart.jsp');
        checkoutCart = await response.json();

        if (checkoutCart.length === 0) {
            productList.innerHTML = '<p style="text-align:center; padding:50px; color:#999; font-family:\'Noto Serif TC\', serif;">購物車內目前沒有商品 ✿</p>';
            cartSubtotal = 0;
            if (listSubtotal) listSubtotal.innerText = `NT$ 0`;
            updateSummary();
            return;
        }

        productList.innerHTML = '';
        cartSubtotal = 0;

        checkoutCart.forEach(item => {
            const itemTotal = item.Price * item.Quantity;
            cartSubtotal += itemTotal;

            const imagePath = `../image/flower/\${item.Category}/\${item.relativeIndex}-1.jpg`;

            productList.innerHTML += `
                <div class="product-item" style="font-family:'Noto Serif TC', serif;">
                    <div class="prod-img">
                        <img src="\${imagePath}" alt="\${item.ProductName}" onerror="this.src='../image/default.jpg'">
                    </div>
                    <div class="prod-details">
                        <p class="name">\${item.ProductName}</p>
                        <p class="price">NT$ \${Number(item.Price).toLocaleString()}</p>
                    </div>
                    <span class="quantity">X\${item.Quantity}</span>
                </div>`;
        });

        if (listSubtotal) listSubtotal.innerText = `NT$ \${cartSubtotal.toLocaleString()}`;
        updateSummary();

    } catch (error) {
        console.error("無法載入結帳商品清單:", error);
        productList.innerHTML = '<p style="text-align:center; padding:50px; color:#f00; font-family:\'Noto Serif TC\', serif;">資料載入異常，請重新整理頁面。✿</p>';
    }
}

async function loadCoupons() {
    const couponSelect = document.getElementById('coupon-select');
    const couponHint = document.getElementById('coupon-hint');

    if (!couponSelect) return;

    try {
        const response = await fetch('get_coupon.jsp');
        const coupons = await response.json();

        couponSelect.innerHTML = '<option value="" data-amount="0">不使用優惠券</option>';

        if (!Array.isArray(coupons) || coupons.length === 0) {
            if (couponHint) couponHint.innerText = '目前沒有可用優惠券。';
            updateSummary();
            return;
        }

        coupons.forEach(coupon => {
            couponSelect.innerHTML += `
                <option value="\${coupon.id}" data-amount="\${coupon.amount}">
                    NT$ \${Number(coupon.amount).toLocaleString()} 折價券
                </option>`;
        });

        if (couponHint) couponHint.innerText = `目前有 \${coupons.length} 張可用優惠券。`;
        updateSummary();

    } catch (error) {
        console.error('無法載入優惠券:', error);
        if (couponHint) couponHint.innerText = '優惠券載入失敗，請稍後再試。';
    }
}

function getSelectedDiscount(maxDiscountTarget) {
    const couponSelect = document.getElementById('coupon-select');
    if (!couponSelect) return 0;

    const selectedOption = couponSelect.options[couponSelect.selectedIndex];
    const amount = Number(selectedOption?.dataset?.amount || 0);

    return Math.min(amount, maxDiscountTarget);
}

function getTotalQuantity() {
    return checkoutCart.reduce((sum, item) => {
        return sum + Number(item.Quantity || 0);
    }, 0);
}

function getEventDiscountInfo() {
    const totalQuantity = getTotalQuantity();

    let rate = 0.9;
    let label = "全店花束 9 折";

    if (totalQuantity >= 2) {
        rate = 0.8;
        label = "購買兩件花束 8 折";
    }

    const discountedSubtotal = Math.round(cartSubtotal * rate);
    const eventDiscount = cartSubtotal - discountedSubtotal;

    return {
        totalQuantity,
        rate,
        label,
        discountedSubtotal,
        eventDiscount
    };
}

function updateSummary() {
    const subtotalDisplay = document.getElementById('subtotal-val');
    const discountDisplay = document.getElementById('discount-val');
    const totalDisplay = document.getElementById('total-val');

    const eventInfo = getEventDiscountInfo();
    const couponDiscount = getSelectedDiscount(eventInfo.discountedSubtotal + SHIPPING_FEE);

    const finalTotal = Math.max(
        eventInfo.discountedSubtotal + SHIPPING_FEE - couponDiscount,
        0
    );

    if (subtotalDisplay) {
        subtotalDisplay.innerText = `NT$ \${cartSubtotal.toLocaleString()}`;
    }

    if (discountDisplay) {
        let discountText = `\${eventInfo.label}：- NT$ \${eventInfo.eventDiscount.toLocaleString()}`;

        if (couponDiscount > 0) {
            discountText += `｜優惠券折抵：- NT$ \${couponDiscount.toLocaleString()}`;
        }

        discountDisplay.innerText = discountText;
    }

    if (totalDisplay) {
        totalDisplay.innerText = `NT$ \${finalTotal.toLocaleString()}`;
    }
}

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
    const couponSelect = document.getElementById('coupon-select');

    const name = nameInput ? nameInput.value.trim() : "";
    const phone = phoneInput ? phoneInput.value.trim() : "";
    const note = noteInput ? noteInput.value.trim() : "";
    const deliveryDate = dateInput ? dateInput.value.trim() : "";
    const address = addressInput ? addressInput.value.trim() : "";
    const paymentMethod = paymentSelect ? paymentSelect.value : "";
    const couponId = couponSelect ? couponSelect.value : "";

    if (!name || !phone || !address || !paymentMethod) {
        alert("請完整填寫收件人姓名、電話、地址與付款方式！✿");
        return;
    }

    const params = new URLSearchParams();
    params.append('name', name);
    params.append('phone', phone);
    params.append('note', note);
    params.append('delivery_date', deliveryDate);
    params.append('address', address);
    params.append('payment_method', paymentMethod);
    params.append('coupon_id', couponId);

    try {
        const checkoutBtn = document.querySelector('.checkout-btn');
        if (checkoutBtn) checkoutBtn.disabled = true;

        const response = await fetch('create_order.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
            },
            body: params.toString()
        });

        const result = await response.json();

        if (result.status === 'success') {
            const overlay = document.getElementById('successOverlay');
            const displayId = document.getElementById('order-id-display');

            if (displayId) {
                displayId.innerText = result.order_number;
            }

            if (overlay) {
                overlay.classList.add('active');
                overlay.onclick = function (e) {
                    if (e.target === overlay) {
                        overlay.classList.remove('active');
                    }
                };
            }
        } else if (result.status === 'invalid_coupon') {
            alert("優惠券無效或已使用，請重新選擇優惠券。✿");
            await loadCoupons();
            if (checkoutBtn) checkoutBtn.disabled = false;
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
