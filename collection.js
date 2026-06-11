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
        fetch('utils/wishlist/check_wishlist.jsp').then(res => res.json()).catch(() => [])
    ])
        .then(([products, wishlistIds]) => {
            dbWishlist = wishlistIds.map(Number);

            let freshCount = 0;
            let driedCount = 0;

            // 💡 核心修正：完美打通 get_products.jsp 傳過來的新舊圖片路徑
            products.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                } else {
                    driedCount++;
                }

                // 判斷 Image 欄位是否存在、是不是新上傳的 UUID 圖片（包含 - 連字號）
                if (flower.Image && flower.Image.trim() !== '' && flower.Image.includes('-')) {
                    // 新產品：直接導向 do_add.jsp 儲存的實體路徑 image/images/
                    flower.imagePath = `image/images/${flower.Image.trim()}`;
                } else {
                    // 舊產品：沿用你原本固定的數字格式路徑
                    if (flower.Category === 'fresh') {
                        flower.imagePath = `image/flower/fresh/${freshCount}-2.jpg`;
                    } else {
                        flower.imagePath = `image/flower/dried/${driedCount}-2.jpg`;
                    }
                }
            });

            // 隨機篩選前台要顯示的 12 筆商品
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

        // 改為正確的 addWish.js 內部函式名稱，確保動態生成或分頁切換後能重新著色
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

async function handleMemberClick() {
    try {
        const response = await fetch("utils/auth/check_session.jsp");
        const loginStatus = await response.text();

        if (loginStatus.trim() === 'true') {
            window.location.href = "member/index.jsp";
        } else {
            window.location.href = "member/login/index.jsp";
        }
    } catch (error) {
        console.error("檢查登入狀態失敗:", error);
        window.location.href = "member/login/index.jsp";
    }
}