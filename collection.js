/**
 * collection.js
 * 功能：從 JSP 載入資料庫商品，與資料庫的願望清單（JSP）即時連動，實作 18 筆隨機推薦、分頁切換、左右箭頭功能
 */

let allFresh = [];
let allDried = [];
let currentFreshPage = 1;
let currentDriedPage = 1;
const itemsPerPage = 6;
let dbWishlist = []; // 儲存自資料庫載入的已收藏 ProductID

window.addEventListener('load', function () {
    Promise.all([
        fetch('get_products.jsp').then(res => res.json()),
        fetch('wishlist/check_wishlist.jsp').then(res => res.json()).catch(() => [])
    ])
        .then(([products, wishlistIds]) => {
            dbWishlist = wishlistIds.map(Number);

            let freshCount = 0;
            let driedCount = 0;

            products.forEach(flower => {
                // 1. 檢查資料庫有沒有存圖片欄位 (flower.Image 或 flower.image，請注意大小寫，依據 get_products.jsp 回傳為主)
                let dbImage = flower.Image || flower.image; 

                if (dbImage && dbImage.trim() !== "") {
                    // 如果是 http/https 開頭的網路圖片網址
                    if (dbImage.startsWith("http://") || dbImage.startsWith("https://")) {
                        flower.imagePath = dbImage;
                    } else {
                        // 如果是本機上傳的 UUID 圖片檔名，指向根目錄下的 images 資料夾
                        flower.imagePath = "image/images/" + dbImage;
                    }
                } else {
                    // 2. 如果資料庫沒圖，才走原本的預設編號流水號圖片邏輯
                    if (flower.Category === 'fresh') {
                        freshCount++;
                        flower.imagePath = `image/flower/fresh/${freshCount}-2.jpg`;
                    } else {
                        driedCount++;
                        flower.imagePath = `image/flower/dried/${driedCount}-2.jpg`;
                    }
                }
            });


            allFresh = products.filter(f => f.Category === 'fresh').sort(() => 0.5 - Math.random()).slice(0, 12);
            allDried = products.filter(f => f.Category === 'dried').sort(() => 0.5 - Math.random()).slice(0, 12);

            renderPage('.fresh-flower', allFresh, 1);
            renderPage('.dried-flower', allDried, 1);

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
            const isFavorited = dbWishlist.includes(Number(flower.ProductID));
            const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
            const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';

            html += `
                <div class="item">
                    <div class="img-box">
                        <a href="product/index.jsp?id=${flower.ProductID}">
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
                                <button class="add-btn-circle" onclick="handleAddToCart(event, ${flower.ProductID})">
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

        // 【修正】改為正確的 addWish.js 內部函式名稱，確保動態生成或分頁切換後能重新著色
        if (typeof updateHeartIconsStatus === 'function') {
            updateHeartIconsStatus();
        }
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

            pageNums.forEach((n, i) => {
                if (i + 1 === p) n.classList.add('active');
                else n.classList.remove('active');
            });

            renderPage(selector, dataList, p);
        };

        pageNums.forEach((btn, i) => {
            btn.onclick = () => update(i + 1);
        });

        if (prevBtn) prevBtn.onclick = () => update(localPage - 1);
        if (nextBtn) nextBtn.onclick = () => update(localPage + 1);
    });
}

function handleAddToCart(event, productId) {
    if (event) event.stopPropagation();
    if (typeof addToCart === "function") {
        addToCart(productId, 1); // 傳入 ID 與 數量 1
    }
}

async function handleMemberClick() {
    try {
        // 向剛剛寫好的 JSP 發送請求
        const response = await fetch("utils/auth/check_session.jsp");
        const loginStatus = await response.text();

        if (loginStatus.trim() === 'true') {
            // 已登入：直接去會員中心
            window.location.href = "member/index.jsp";
        } else {
            // 未登入：去登入頁面
            window.location.href = "member/login/index.jsp";
        }
    } catch (error) {
        console.error("檢查登入狀態失敗:", error);
        // 發生網路錯誤時的防錯防護：預防萬一導向登入頁
        window.location.href = "member/login/index.jsp";
    }
}