/**
 * collection.js
 * 功能：實作 18 筆隨機推薦、分頁切換、左右箭頭功能
 */

let allFresh = [];
let allDried = [];
let currentFreshPage = 1;
let currentDriedPage = 1;
const itemsPerPage = 6;
const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];

window.addEventListener('load', function () {
    fetch('flowerData.json')
        .then(response => response.json())
        .then(data => {
            // 隨機挑選 12 筆 (或是全部，若不足 12)
            allFresh = data.filter(f => f.is_fresh === true).sort(() => 0.5 - Math.random()).slice(0, 12);
            allDried = data.filter(f => f.is_fresh === false).sort(() => 0.5 - Math.random()).slice(0, 12);

            // 初始渲染
            renderPage('.fresh-flower', allFresh, 1);
            renderPage('.dried-flower', allDried, 1);

            // 綁定事件
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
            const imagePath = `image/flower/${flower.image_path}-2.jpg`;
            const isFavorited = wishlist.includes(flower.id);
            const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
            const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';
            html += `
                <div class="item">
                    <div class="img-box">
                        <a href="product/index.html?id=${flower.id}">
                            <img src="${imagePath}" alt="${flower.name}" onerror="this.src=''">
                        </a>
                    </div>
                    <div class="item-info">
                        <div class="info-top">
                            <span class="tag">${flower.name}<br>[${flower.series}]</span>
                            <div class="item-actions">
                                <button class="action-btn-circle heart-btn" data-id="${flower.id}"><i class="${heartIconClass} fa-heart" ${heartIconStyle}></i></button>
                                <button class="add-btn-circle" onclick="handleAddToCart(event, '${flower.name}', ${flower.price})"><i class="fa-solid fa-plus"></i></button>
                            </div>
                        </div>
                        <span class="price">NT$ ${flower.price.toLocaleString()}</span>
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
    // 獲取所有 collection 區塊
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
    // 1. 阻止事件冒泡，防止 utils/cart/main.js 的 document.click 又跑一次
    if (event) event.stopPropagation();

    // 2. 呼叫 utils/cart/main.js 的功能
    if (typeof addToCart === "function") {
        addToCart(name, price);
    }
}