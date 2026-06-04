/**
 * collection.js
 * 功能：從 JSP 載入資料庫商品，與資料庫的願望清單（JSP）即時連動，實作 18 筆隨機推薦、分頁切換、左右箭頭功能
 * 附加：內建 addWish.js 載入失敗時的自動接管防錯機制
 */

let allFresh = [];
let allDried = [];
let currentFreshPage = 1;
let currentDriedPage = 1;
const itemsPerPage = 6;
let dbWishlist = []; // 儲存自資料庫載入的已收藏 ProductID

window.addEventListener('load', function () {
    // 使用 Promise.all 同時發送商品與收藏狀態的請求，大幅縮短載入時間
    Promise.all([
        fetch('get_products.jsp').then(res => res.json()),
        fetch('wishlist/check_wishlist.jsp').then(res => res.json()).catch(() => []) // 若未登入，則寬容回傳空陣列
    ])
        .then(([products, wishlistIds]) => {
            // 確保將所有的 ID 都轉成數值型態以便後續比對
            dbWishlist = wishlistIds.map(Number);

            let freshCount = 0;
            let driedCount = 0;

            // 1. 在隨機打亂前，先依據原始順序為每一筆資料動態賦予正確的圖片路徑
            products.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                    flower.imagePath = `image/flower/fresh/${freshCount}-2.jpg`;
                } else {
                    driedCount++;
                    flower.imagePath = `image/flower/dried/${driedCount}-2.jpg`;
                }
            });

            // 2. 分類篩選、隨機打亂、挑選 12 筆推薦
            allFresh = products.filter(f => f.Category === 'fresh').sort(() => 0.5 - Math.random()).slice(0, 12);
            allDried = products.filter(f => f.Category === 'dried').sort(() => 0.5 - Math.random()).slice(0, 12);

            // 3. 初始渲染
            renderPage('.fresh-flower', allFresh, 1);
            renderPage('.dried-flower', allDried, 1);

            // 4. 綁定分頁與切換事件
            setupPaginationEvents();
        })
        .catch(err => console.error("資料載入失敗:", err));
});

function renderPage(selector, dataList, page) {
    const container = document.querySelector(selector);
    if (!container) return;

    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageData = dataList.slice(start, end);

    container.classList.add('fade-out');

    setTimeout(() => {
        let html = '';
        pageData.forEach(flower => {
            // 與資料庫中已收藏的 ProductID 陣列進行精準比對
            const isFavorited = dbWishlist.includes(Number(flower.ProductID));
            const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
            const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';

            html += `
                <div class="item">
                    <div class="img-box">
                        <a href="product/index.html?id=${flower.ProductID}">
                            <img src="${flower.imagePath}" alt="${flower.ProductName}" onerror="this.src=''">
                        </a>
                    </div>
                    <div class="item-info">
                        <div class="info-top">
                            <span class="tag">${flower.ProductName}<br>[${flower.Series}]</span>
                            <div class="item-actions">
                                <button class="action-btn-circle heart-btn" data-id="${flower.ProductID}">
                                    <i class="${heartIconClass} fa-heart" ${heartIconStyle}></i>
                                </button>
                                <button class="add-btn-circle" onclick="handleAddToCart(event, '${flower.ProductName}', ${flower.Price})">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                            </div>
                        </div>
                        <span class="price">NT$ ${flower.Price.toLocaleString()}</span>
                    </div>
                </div>
            `;
        });
        container.innerHTML = html;
        container.classList.remove('fade-out');
        if (typeof syncHeartIcons === 'function') syncHeartIcons();
    }, 300);
}

function setupPaginationEvents() {
    const collections = document.querySelectorAll('.collection');

    collections.forEach(section => {
        const grid = section.querySelector('.grid-3x2, .grid-2x3');
        if (!grid) return;

        const isFresh = grid.classList.contains('fresh-flower');
        const dataList = isFresh ? allFresh : allDried;
        const selector = isFresh ? '.fresh-flower' : '.dried-flower';

        let localPage = 1;

        const pageNums = section.querySelectorAll('.page-num');
        const prevBtn = section.querySelector('.fa-chevron-left');
        const nextBtn = section.querySelector('.fa-chevron-right');

        const update = (p) => {
            if (p < 1 || p > Math.ceil(dataList.length / itemsPerPage)) return;
            localPage = p;

            // 更新數字 UI
            pageNums.forEach((n, i) => {
                if (i + 1 === p) n.classList.add('active');
                else n.classList.remove('active');
            });

            renderPage(selector, dataList, p);
        };

        // 數字點擊
        pageNums.forEach((btn, i) => {
            btn.onclick = () => update(i + 1);
        });

        // 左右箭頭
        if (prevBtn) prevBtn.onclick = () => update(localPage - 1);
        if (nextBtn) nextBtn.onclick = () => update(localPage + 1);
    });
}

function handleAddToCart(event, name, price) {
    if (event) event.stopPropagation();
    if (typeof addToCart === "function") {
        addToCart(name, price);
    }
}

// 監聽全域愛心點擊：內建 addWish.js 載入失敗時的自動防護與接管
document.addEventListener('click', function (e) {
    const heartBtn = e.target.closest('.heart-btn');
    if (!heartBtn) return;

    const productId = Number(heartBtn.getAttribute('data-id'));
    if (!productId) return;

    // A. 降級接管邏輯：如果 addWish.js 載入失敗 (toggleWishlist 未定義)，直接由首頁代為發送請求
    if (typeof toggleWishlist !== 'function') {
        fetch(`wishlist/toggle_wishlist.jsp?product_id=${productId}`)
            .then(response => response.text())
            .then(result => {
                const res = result.trim();
                if (res === 'added') {
                    showCollectionHeartFeedback(heartBtn, true);
                    if (!dbWishlist.includes(productId)) {
                        dbWishlist.push(productId);
                    }
                    showToastMessage("已加入願望清單 ✿");
                } else if (res === 'removed') {
                    showCollectionHeartFeedback(heartBtn, false);
                    dbWishlist = dbWishlist.filter(id => id !== productId);
                    showToastMessage("已從願望清單移除 ✿");
                } else if (res === 'nologin') {
                    showToastMessage("此功能僅限會員使用，請先登入帳號 ✿");
                    setTimeout(() => {
                        window.location.href = "member/login/index.html";
                    }, 1000);
                }
            })
            .catch(err => console.error("首頁 Wishlist 自主接管對接錯誤:", err));
    }
    // B. 原生同步邏輯：如果 addWish.js 存在，則讓其執行，並在 250ms 後同步 dbWishlist 記憶體狀態
    else {
        setTimeout(() => {
            const icon = heartBtn.querySelector('i');
            if (icon && icon.classList.contains('fa-solid')) {
                if (!dbWishlist.includes(productId)) {
                    dbWishlist.push(productId);
                }
            } else {
                dbWishlist = dbWishlist.filter(id => id !== productId);
            }
        }, 250);
    }
});

// 首頁愛心動畫反饋函數
function showCollectionHeartFeedback(btn, isAdded) {
    const icon = btn.querySelector('i');
    btn.style.transition = "transform 0.2s";
    btn.style.transform = "scale(1.3)";

    setTimeout(() => {
        btn.style.transform = "scale(1)";
        if (isAdded) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = "#c0a080";
        } else {
            icon.classList.replace('fa-solid', 'fa-regular');
            icon.style.color = "";
        }
    }, 200);
}

// 首頁 Toast 訊息框
function showToastMessage(message) {
    let toast = document.getElementById('custom-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'custom-toast';
        toast.style.cssText = `
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(112, 88, 68, 0.95);
            color: #fff;
            padding: 12px 24px;
            border-radius: 30px;
            font-family: 'Noto Serif TC', serif;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            z-index: 9999;
            transition: opacity 0.3s ease;
            opacity: 0;
            pointer-events: none;
            text-align: center;
        `;
        document.body.appendChild(toast);
    }
    toast.innerText = message;
    toast.style.opacity = '1';
    setTimeout(() => {
        toast.style.opacity = '0';
    }, 2000);
}