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

    // 3. 抓取 JSP 即時資料庫資料
    fetch('../get_products.jsp')
        .then(response => response.json())
        .then(data => {
            // 在篩選與裁剪前，先依據資料庫原始順序動態計算每筆商品的 relativeIndex，確保圖片路徑精準無誤
            let freshCount = 0;
            let driedCount = 0;
            data.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                    flower.relativeIndex = freshCount;
                } else {
                    driedCount++;
                    flower.relativeIndex = driedCount;
                }
            });

            // 篩選出該系列的所有產品 (注意對齊資料庫新欄位 Series)
            const seriesFlowers = data.filter(flower => flower.Series === targetSeriesName);

            // 執行渲染 (每個系列取前 8 朵)
            renderSeriesProducts(seriesFlowers.slice(0, 8));
        })
        .catch(err => console.error("資料載入失敗:", err));
});

/**
 * 將篩選後的資料渲染至 HTML (已對齊 SQL 資料庫欄位)
 * @param {Array} flowers 
 */
function renderSeriesProducts(flowers) {
    const productGrid = document.querySelector('.product-grid');
    if (!productGrid) return;

    if (flowers.length === 0) {
        productGrid.innerHTML = `<p style="text-align:center; padding:50px; color:#999; width:100%;">目前該系列尚無商品 ✿</p>`;
        return;
    }

    // 先取得願望清單，避免在 map 迴圈內重複讀取 localStorage
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];

    productGrid.innerHTML = flowers.map(flower => {
        // 判斷該商品是否已被收藏 (將 ProductID 轉為字串進行比對防錯)
        const isFavorited = wishlist.includes(flower.ProductID.toString()) || wishlist.includes(flower.ProductID);
        const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
        const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';

        // 組裝出精確的縮圖路徑 (使用動態相對目錄編號)
        const fullImagePath = `../image/flower/${flower.Category}/${flower.relativeIndex}-1.jpg`;

        return `
            <div class="item">
                <div class="img-box">
                    <a href="../product/index.html?id=${flower.ProductID}">
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
                            <button class="add-btn-circle" onclick="handleAddToCart(event, '${flower.ProductName}', ${flower.Price})">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </div>
                    <span class="price">NT$ ${flower.Price.toLocaleString()}</span>
                </div>
            </div>
        `;
    }).join('');
}