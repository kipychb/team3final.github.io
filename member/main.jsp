<%@ page contentType = "text/javascript;charset=utf-8" language = "java" %>

function flowerImg(image, variant, prefix) {
    prefix = prefix !== undefined ? prefix : '../';
    if (!image || image === 'null' || image.trim() === '') return prefix + 'image/default.jpg';
    const img = image.trim();
    if (/^\d+-1\.jpg$/.test(img)) {
        return prefix + 'image/flower/' + img.replace('-1.jpg', '-' + variant + '.jpg');
    }
    return prefix + 'image/flower/' + img;
}

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
                // 💡 修正：動態相容新 UUID 圖片與舊 indexed 圖片路徑，並移除路徑多餘空格
                const imgPath = flowerImg(detail.Image, 1);

                return `
                    <div class="order-product-row" style="display: flex; gap: 15px; align-items: center; margin-bottom: 12px; border-bottom: 1px dashed #eee; padding-bottom: 12px;">
                        <img src="\${imgPath}" alt="\${detail.ProductName}" onerror="this.src='../image/default.jpg'" style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <p style="font-weight: bold; color: #705844; margin: 0;">\${detail.ProductName}</p>
                            <p style="font-size: 0.85rem; color: #888; margin: 4px 0 0 0;">NT$ \${detail.Price.toLocaleString()} &times; \${detail.Quantity}</p>
                        </div>
                        <span style="font-weight: bold; color: #705844;">NT$ \${detail.Subtotal.toLocaleString()}</span>
                    </div>
                `;
            }).join('');

            return `
                <div class="order-card" style="background: #fff; border: 1px solid #eae1d8; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(112, 88, 68, 0.05); font-family: 'Noto Serif TC', serif;">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eae1d8; padding-bottom: 10px; margin-bottom: 15px;">
                        <div>
                            <span style="font-size: 0.85rem; color: #888;">訂單編號：</span>
                            <span style="font-weight: bold; color: #705844;">\${order.OrderNumber}</span>
                        </div>
                        <span class="\${statusClass}" style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem;">\${order.OrderStatus}</span>
                    </div>
                    
                    <!-- 商品明細列表 -->
                    <div class="order-products">
                        \${detailsHtml}
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px; font-size: 0.9rem; color: #666;">
                        <div>
                            <p style="margin: 0;">訂購日期：\${order.OrderDate}</p>
                            <p style="margin: 4px 0 0 0;">付款方式：\${displayPayment}</p>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-size: 0.85rem; color: #888;">總金額 (含運費)：</span>
                            <span style="font-size: 1.2rem; font-weight: bold; color: #705844;">NT$ \${order.TotalAmount.toLocaleString()}</span>
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

/**
 * 【重構功能】從資料庫讀取會員願望清單並渲染
 */
async function renderMemberWishlist() {
    const container = document.querySelector('#wishlist .list-container');
    if (!container) return;

    container.innerHTML = '<p style="text-align:center; padding:30px; color:#999; font-family:\'Noto Serif TC\', serif;">讀取您的願望清單中... ✿</p>';

    try {
        // 從 ../utils/wishlist/get_wishlist.jsp 取得此會員在 SQL 中的收藏資料
        const response = await fetch('../utils/wishlist/get_wishlist.jsp');
        const wishlistedItems = await response.json();

        if (wishlistedItems.length === 0) {
            container.innerHTML = '<p style="text-align:center; padding:40px; color:#999; font-family:\'Noto Serif TC\', serif; width:100%;">您的願望清單空空如也... ✿</p>';
            return;
        }

        // 使用網格(Grid)或彈性盒(Flex)將卡片整齊排列
        container.innerHTML = `
            <div class="member-wishlist-grid">
                \${wishlistedItems.map(item => {
                    // 💡 修正：移除路徑中的所有多餘空格，並加入 UUID 新圖片格式解析
                    const imagePath = flowerImg(item.Image, 2);

                    const productUrl = `../product/index.jsp?id=\${item.ProductID}`;
                    return `
                        <div class="member-wish-card">
                            <div class="wish-img-box">
                                <a href="\${productUrl}">
                                    <img src="\${imagePath}" alt="\${item.ProductName}" onerror="this.src='../image/default.jpg'">
                                </a>
                                <button class="wish-remove-btn" onclick="removeFromMemberWishlist('\${item.ProductID}')" title="移除願望">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </div>
                            <div class="wish-info">
                                <div class="wish-text">
                                    <p class="wish-name">\${item.ProductName}</p>
                                    <p class="wish-series">\${item.Series} 系列</p>
                                    <p class="wish-price">NT$ \${item.Price.toLocaleString()}</p>
                                </div>
                                <div class="wish-actions">
                                    <div class="share-wrapper" style="position: relative;">
                                        <button class="wish-mini-btn share-btn" onclick="copyMemberProductLink('\${productUrl}', this)" title="分享連結">
                                            <i class="fa-solid fa-share-nodes"></i>
                                        </button>
                                        <span class="tooltip">複製成功！</span>
                                    </div>
                                    <button class="wish-mini-btn add-cart-btn" onclick="addToCartFromWishlist('\${item.ProductID}', '\${item.ProductName}')" title="加入購物車">
                                        <i class="fa-solid fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                }).join('')}
            </div>
        `;
    } catch (error) {
        console.error("載入願望清單失敗:", error);
        container.innerHTML = '<p style="text-align:center; padding:30px; color:#f00; font-family:\'Noto Serif TC\', serif;">載入願望清單失敗，請稍後再試。✿</p>';
    }
}

/**
 * 【新功能】自願望清單移除商品 (直連後端資料庫)
 */
function removeFromMemberWishlist(productId) {
    // 💡 修正：移除 fetch 路徑中的所有多餘空格，防止瀏覽器發送錯亂的 404 URL 請求
    fetch(`../utils/wishlist/toggle_wishlist.jsp?product_id=\${productId}`)
        .then(response => response.text())
        .then(result => {
            if (result.trim() === 'removed') {
                // 成功移除後，重新呼叫 render 刷新網頁
                renderMemberWishlist();
                if (typeof updateHeartIconsStatus === 'function') {
                    updateHeartIconsStatus();
                }
            } else if (result.trim() === 'nologin') {
                alert("登入逾時，請重新登入！");
                window.location.href = 'login/index.jsp';
            }
        })
        .catch(err => {
            console.error("移除願望失敗:", err);
            alert("網路異常，無法移除願望！");
        });
}

/**
 * 【新功能】複製商品詳細頁面連結 (含 Tooltip)
 */
function copyMemberProductLink(url, btnElement) {
    // 取得絕對網址
    const fullUrl = window.location.origin + window.location.pathname.replace('member/index.jsp', '').replace('member/', '') + url.replace('../', '');

    const tempInput = document.createElement('input');
    tempInput.value = fullUrl;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand('copy');
    document.body.removeChild(tempInput);

    // 顯示「複製成功」提示
    const tooltip = btnElement.parentElement.querySelector('.tooltip');
    if (tooltip) {
        tooltip.classList.add('show');
        setTimeout(() => {
            tooltip.classList.remove('show');
        }, 1500);
    }
}

// 4. 加入購物車功能 (連動資料庫驅動版購物車核心)
function addToCartFromWishlist(productId, productName) {
    if (typeof addToCart === 'function') {
        // 調用 utils/cart/main.jsp 中的資料庫核心加入購物車方法
        addToCart(productId, 1);
    } else {
        console.error("購物車核心模組 (utils/cart/main.jsp) 未成功載入！");
        alert("購物車系統暫時發生異常，請稍後再試。✿");
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

        // 💡 修正：移除 POST body 中變數等號前後的多餘空格，確保變數鍵值對傳遞格式正確
        fetch('update_profile.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `name=\${encodeURIComponent(nameVal)}&birth=\${encodeURIComponent(birthVal)}&email=\${encodeURIComponent(emailVal)}&phone=\${encodeURIComponent(phoneVal)}`
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

document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    if (tab) {
        // 尋找對應的 flower-item 元件，其 onclick 事件字串包含目標分頁名稱
        const targetBtn = Array.from(document.querySelectorAll('.flower-item')).find(item => {
            const attr = item.getAttribute('onclick');
            return attr && attr.includes(`'\${tab}'`);
        });
        if (targetBtn) {
            switchSection(tab, targetBtn);
        }
    }
});