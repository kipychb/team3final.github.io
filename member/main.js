// member/main.js

// 2. 切換分頁邏輯 
function switchSection(id, element) {
    // 切換選單按鈕樣式
    document.querySelectorAll('.flower-item').forEach(item => item.classList.remove('active'));
    element.classList.add('active');

    // 切換內容區塊
    document.querySelectorAll('.section-block').forEach(block => block.classList.remove('active'));
    const targetBlock = document.getElementById(id);
    if (targetBlock) {
        targetBlock.classList.add('active');
    }

    if (id === 'wishlist') {
        renderMemberWishlist();
    } else if (id === 'orders') {
        loadMemberOrders();
    }
}

/**
 * 【新功能】非同步向後端獲取會員專屬訂單紀錄並渲染
 */
async function loadMemberOrders() {
    const container = document.querySelector('#orders .list-container');
    if (!container) return;

    container.innerHTML = '<p style="text-align:center; padding:30px; color:#999; font-family:\'Noto Serif TC\', serif;">正在讀取您的訂單紀錄... ✿</p>';

    try {
        const response = await fetch('get_member_orders.jsp');
        const orders = await response.json();

        if (orders.length === 0) {
            container.innerHTML = '<p style="text-align:center; padding:40px; color:#999; font-family:\'Noto Serif TC\', serif;">目前沒有任何訂單紀錄 ✿</p>';
            return;
        }

        container.innerHTML = orders.map(order => {
            // 付款方式轉換顯示
            const paymentMap = {
                'credit': '信用卡線上支付',
                'transfer': '銀行轉帳 (自動對帳)',
                'linepay': 'LINE Pay 快速結帳'
            };
            const displayPayment = paymentMap[order.OrderType] || order.OrderType;

            // 狀態顏色標籤處理
            let statusClass = "status-tag";
            if (order.OrderStatus === '已付款') {
                statusClass += " highlight";
            } else if (order.OrderStatus === '已出貨') {
                statusClass += " shipped"; // 可自行於 CSS 擴充樣式
            } else if (order.OrderStatus === '完成') {
                statusClass += " completed";
            }

            // 渲染商品詳情細項
            const detailsHtml = order.Details.map(detail => {
                const imgPath = `../image/flower/${detail.Category}/${detail.relativeIndex}-1.jpg`;
                return `
                    <div class="order-product-row" style="display: flex; gap: 15px; align-items: center; margin-bottom: 12px; border-bottom: 1px dashed #eee; padding-bottom: 12px;">
                        <img src="${imgPath}" alt="${detail.ProductName}" onerror="this.src='../image/default.jpg'" style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <p style="font-weight: bold; color: #705844; margin: 0;">${detail.ProductName}</p>
                            <p style="font-size: 0.85rem; color: #888; margin: 4px 0 0 0;">NT$ ${detail.Price.toLocaleString()} &times; ${detail.Quantity}</p>
                        </div>
                        <span style="font-weight: bold; color: #705844;">NT$ ${detail.Subtotal.toLocaleString()}</span>
                    </div>
                `;
            }).join('');

            return `
                <div class="order-card" style="background: #fff; border: 1px solid #eae1d8; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(112, 88, 68, 0.05); font-family: 'Noto Serif TC', serif;">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eae1d8; padding-bottom: 10px; margin-bottom: 15px;">
                        <div>
                            <span style="font-size: 0.85rem; color: #888;">訂單編號：</span>
                            <span style="font-weight: bold; color: #705844;">${order.OrderNumber}</span>
                        </div>
                        <span class="${statusClass}" style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem;">${order.OrderStatus}</span>
                    </div>
                    
                    <!-- 商品明細列表 -->
                    <div class="order-products">
                        ${detailsHtml}
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px; font-size: 0.9rem; color: #666;">
                        <div>
                            <p style="margin: 0;">訂購日期：${order.OrderDate}</p>
                            <p style="margin: 4px 0 0 0;">付款方式：${displayPayment}</p>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-size: 0.85rem; color: #888;">總金額 (含運費)：</span>
                            <span style="font-size: 1.2rem; font-weight: bold; color: #705844;">NT$ ${order.TotalAmount.toLocaleString()}</span>
                        </div>
                    </div>
                </div>
            `;
        }).join('');

    } catch (error) {
        console.error("載入訂單失敗:", error);
        container.innerHTML = '<p style="text-align:center; padding:30px; color:#f00; font-family:\'Noto Serif TC\', serif;">載入訂單失敗，請稍後再試。✿</p>';
    }
}

// 3. 願望清單渲染 
function renderMemberWishlist() {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const container = document.querySelector('#wishlist .list-container');

    if (!container) return;

    if (wishlist.length === 0) {
        container.innerHTML = '<p style="text-align:center; padding:30px; color:#999; width:100%;">目前沒有收藏的願望 ✿</p>';
        return;
    }

    container.innerHTML = wishlist.map((item, index) => `
        <div class="wish-item-row">
            <div class="wish-text">
                <p class="wish-name">${item.name}</p>
                <p class="wish-price">NT$ ${item.price.toLocaleString()}</p>
            </div>
            <button class="mini-add-btn" onclick="addToCartFromWishlist('${item.name}', ${item.price}, '${item.image}')">
                <i class="fa-solid fa-plus"></i>
            </button>
        </div>
    `).join('');
}

// 4. 加入購物車功能 
function addToCartFromWishlist(name, price, image) {
    let cart = JSON.parse(localStorage.getItem('myCart')) || [];
    const existingItem = cart.find(item => item.name === name);

    if (existingItem) {
        existingItem.qty += 1;
    } else {
        cart.push({ name, price, image, qty: 1 });
    }

    localStorage.setItem('myCart', JSON.stringify(cart));
    alert(`✿ 「${name}」已加入購物車 ✿`);

    if (typeof updateCartUI === 'function') {
        updateCartUI();
    }
}

// 5. 會員資料修改模式
let isEditMode = false;
function toggleEditMode() {
    const editBtn = document.getElementById('edit-btn');
    const fields = [
        { id: 'name', display: 'display-name', input: 'edit-name' },
        { id: 'birth', display: 'display-birth', input: 'edit-birth' },
        { id: 'email', display: 'display-email', input: 'edit-email' },
        { id: 'phone', display: 'display-phone', input: 'edit-phone' }
    ];

    if (!isEditMode) {
        isEditMode = true;
        editBtn.innerText = "儲存修改資料";
        editBtn.classList.add('save-mode');

        fields.forEach(field => {
            const displaySpan = document.getElementById(field.display);
            const inputField = document.getElementById(field.input);
            if (displaySpan && inputField) {
                inputField.value = displaySpan.innerText.trim();
                displaySpan.style.display = 'none';
                inputField.style.display = 'inline-block';
            }
        });
    } else {
        const nameVal = document.getElementById('edit-name').value;
        const birthVal = document.getElementById('edit-birth').value;
        const emailVal = document.getElementById('edit-email').value;
        const phoneVal = document.getElementById('edit-phone').value;

        fetch('update_profile.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `name=${encodeURIComponent(nameVal)}&birth=${encodeURIComponent(birthVal)}&email=${encodeURIComponent(emailVal)}&phone=${encodeURIComponent(phoneVal)}`
        })
            .then(response => response.text())
            .then(result => {
                if (result.trim() === 'success') {
                    isEditMode = false;
                    editBtn.innerText = "修改個人資料";
                    editBtn.classList.remove('save-mode');

                    fields.forEach(field => {
                        const displaySpan = document.getElementById(field.display);
                        const inputField = document.getElementById(field.input);
                        if (displaySpan && inputField) {
                            displaySpan.innerText = inputField.value;
                            displaySpan.style.display = 'inline-block';
                            inputField.style.display = 'none';
                        }
                    });
                    alert("已為您更新會員資料!");
                } else if (result.trim() === 'nologin') {
                    alert("登入逾時，請重新登入！");
                } else {
                    alert("資料更新失敗，請檢查輸入內容是否正確！");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("網路異常，無法與伺服器取得連線！");
            });
    }
}

// 6. 訂單卡片點擊監聽 (保持不變)
document.addEventListener('click', (e) => {
    const card = e.target.closest('.order-card');
    if (card) {
        if (e.target.tagName === 'A') return;
        const itemNameLink = card.querySelector('.item-name');
        if (itemNameLink) {
            window.location.href = itemNameLink.getAttribute('href');
        }
    }
});

// 7. 登出帳號功能
function logout() {
    window.location.href = 'logout.jsp';
}

function toggleCouponBox() {
    var box = document.getElementById("coupon-box");

    if (box.style.display === "none") {
        box.style.display = "block";
    } else {
        box.style.display = "none";
    }
}