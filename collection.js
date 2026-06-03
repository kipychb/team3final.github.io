/**
 * collection.js
 * 功能：從 JSP 載入資料庫商品，實作 18 筆隨機推薦、分頁切換、左右箭頭功能
 */

let allFresh = [];
let allDried = [];
let currentFreshPage = 1;
let currentDriedPage = 1;
const itemsPerPage = 6;
const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];

window.addEventListener('load', function () {
    // 改為向 get_products.jsp 請求即時資料庫資料
    fetch('get_products.jsp')
        .then(response => response.json())
        .then(data => {
            let freshCount = 0;
            let driedCount = 0;

            // 1. 在隨機打亂前，先依據原始順序為每一筆資料動態賦予正確的圖片路徑
            data.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                    flower.imagePath = `image/flower/fresh/${freshCount}-2.jpg`;
                } else {
                    driedCount++;
                    flower.imagePath = `image/flower/dried/${driedCount}-2.jpg`;
                }
            });

            // 2. 分類篩選、隨機打亂、挑選 12 筆推薦
            allFresh = data.filter(f => f.Category === 'fresh').sort(() => 0.5 - Math.random()).slice(0, 12);
            allDried = data.filter(f => f.Category === 'dried').sort(() => 0.5 - Math.random()).slice(0, 12);

            // 3. 初始渲染
            renderPage('.fresh-flower', allFresh, 1);
            renderPage('.dried-flower', allDried, 1);

            // 4. 綁定分頁與切換事件
            setupPaginationEvents();
        })
        .catch(err => console.error("資料庫載入失敗:", err));
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
            // 檢查該商品是否已被加入收藏 (將 ID 轉為字串進行比對)
            const isFavorited = wishlist.includes(flower.ProductID.toString()) || wishlist.includes(flower.ProductID);
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