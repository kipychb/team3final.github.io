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

    // 3. 抓取 JSON 資料
    fetch('../flowerData.json')
        .then(response => response.json())
        .then(data => {
            // 篩選出該系列的所有產品
            const seriesFlowers = data.filter(flower => flower.series === targetSeriesName);

            // 執行渲染 (假設每個系列取前 8 朵)
            renderSeriesProducts(seriesFlowers.slice(0, 8));
        })
        .catch(err => console.error("資料載入失敗:", err));
});

/**
 * 將篩選後的資料渲染至 HTML
 * @param {Array} flowers 
 */
function renderSeriesProducts(flowers) {
    const productGrid = document.querySelector('.product-grid');
    if (!productGrid) return;

    if (flowers.length === 0) {
        productGrid.innerHTML = `<p>目前該系列尚無商品</p>`;
        return;
    }

    // 先取得願望清單，避免在 map 迴圈內重複讀取 localStorage
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];

    productGrid.innerHTML = flowers.map(flower => {
        // 在這裡判斷該商品是否已被收藏
        const isFavorited = wishlist.includes(flower.id);
        const heartIconClass = isFavorited ? 'fa-solid' : 'fa-regular';
        const heartIconStyle = isFavorited ? 'style="color: #c0a080;"' : '';

        return `
            <div class="item">
                <div class="img-box">
                    <a href="../product/index.html?id=${flower.id}">
                        <img src="../image/flower/${flower.image_path}-1.jpg" alt="${flower.name}" onerror="this.src=''">
                    </a>
                </div>
                <div class="item-info">
                    <div class="info-top">
                        <span class="tag">${flower.name}<br>[${flower.series}]</span>
                        <div class="item-actions">
                            <button class="action-btn-circle heart-btn" data-id="${flower.id}">
                                <i class="${heartIconClass} fa-heart" ${heartIconStyle}></i>
                            </button>
                            <button class="add-btn-circle" onclick="handleAddToCart(event, '${flower.name}', ${flower.price})">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </div>
                    <span class="price">NT$ ${flower.price.toLocaleString()}</span>
                </div>
            </div>
        `;
    }).join('');
}