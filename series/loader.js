/**
 * loader.js (series/loader.js)
 * 功能：系列商品頁面自動載入器 - SQL 資料庫對接版
 * 說明：從 JSP 載入商品，與資料庫的願望清單、購物車進行即時連動，支援 4 種系列分類
 */

dbWishlist = []; // 儲存自資料庫載入的已收藏 ProductID

window.addEventListener('load', function () {
    // 1. 取得網址參數 ?series=
    const urlParams = new URLSearchParams(window.location.search);
    const seriesParam = urlParams.get('series'); // 例如: lover, elder, friend, myself

    // 2. 定義對應關係
    const seriesMap = {
        'lover': 'For Lover',
        'elder': 'For Elders',
        'friend': 'For Friend',
        'myself': 'For Myself'
    };

    const targetSeriesName = seriesMap[seriesParam];

    if (!targetSeriesName) {
        console.error("未找到對應的系列參數，請確認網址格式是否正確");
        return;
    } else {
        // 修改 section-title
        document.getElementsByClassName("section-title")[0].innerHTML = "［" + targetSeriesName + "系列］";
    }

    // 3. 同時獲取商品清單與資料庫願望清單 (大幅縮短載入時間與解決生命週期時間差)
    Promise.all([
        fetch('../get_products.jsp').then(res => res.json()),
        fetch('../utils/wishlist/check_wishlist.jsp').then(res => res.json()).catch(() => []) // 若未登入，則寬容回傳空陣列
    ])
        .then(([products, wishlistIds]) => {
            // 確保將所有的 ID 都轉成數值型態以便後續比對
            dbWishlist = wishlistIds.map(Number);

            // 在篩選與裁剪前，先依據資料庫原始順序動態計算每筆商品的 relativeIndex，確保圖片路徑精準無誤
            let freshCount = 0;
            let driedCount = 0;
            products.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                    flower.relativeIndex = freshCount;
                } else {
                    driedCount++;
                    flower.relativeIndex = driedCount;
                }
            });

            // 篩選出該系列的所有產品
            const seriesFlowers = products.filter(flower => flower.Series === targetSeriesName);

            // 執行渲染 (每個系列取前 8 朵)
            renderSeriesProducts(seriesFlowers.slice(0, 8));
        })
        .catch(err => console.error("資料載入失敗:", err));
});

/**
 * 將篩選後的資料渲染至 HTML (已對齊 SQL 資料庫欄位與無 CartID 機制)
 * @param {Array} flowers 
 */
function renderSeriesProducts(flowers) {
    const productGrid = document.querySelector('.product-grid');
    if (!productGrid) return;

    if (flowers.length === 0) {
        productGrid.innerHTML = `<p style="text-align:center; padding:50px; color:#999; width:100%;">目前該系列尚無商品 ✿</p>`;
        return;
    }

    productGrid.innerHTML = flowers.map(flower => {
        // 與資料庫中已收藏的 ProductID 陣列進行精準比對
        const isFavorited = dbWishlist.includes(Number(flower.ProductID));
        const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
        const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';

        // 組裝出精確的縮圖路徑 (使用動態相對目錄編號)
        const fullImagePath = `../image/flower/${flower.Category}/${flower.relativeIndex}-1.jpg`;

        return `
            <div class="item">
                <div class="img-box">
                    <a href="../product/index.jsp?id=${flower.ProductID}">
                        <img src="${fullImagePath}" alt="${flower.ProductName}" onerror="this.src='../image/default.jpg'">
                    </a>
                </div>
                <div class="item-info">
                    <div class="info-top">
                        <span class="tag">${flower.ProductName}<br>[${flower.Series} 系列]</span>
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
    }).join('');

    // 【修正】動態 HTML 生成完畢後，立刻通知 addWish.js 更新愛心點擊監聽與樣式
    if (typeof updateHeartIconsStatus === 'function') {
        updateHeartIconsStatus();
    }
}

/**
 * 中間接管函式：點擊加號按鈕，傳遞 ProductID 給 utils/cart/main.js
 */
function handleAddToCart(event, productId) {
    if (event) event.stopPropagation();
    if (typeof addToCart === "function") {
        // 直接傳入 ProductID 進行 SQL 寫入 (預設數量為 1)
        addToCart(productId, 1);
    } else {
        console.error("找不到 addToCart 函式，請確認 utils/cart/main.js 已正確載入。");
    }
}