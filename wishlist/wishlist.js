/**
 * wishlist.js
 * 功能：讀取 flowerData.json，並根據 localStorage 的 ID 陣列 (myWishlist) 渲染頁面
 */

document.addEventListener('DOMContentLoaded', () => {
    renderWishlist();
});

async function renderWishlist() {
    const gridContainer = document.querySelector('.wishlist-container .grid');
    if (!gridContainer) return;

    // 1. 取得收藏的 ID 列表 (只存 ID 的陣列，例如 ["slow_time", "aurora"])
    const wishlistIds = JSON.parse(localStorage.getItem('myWishlist')) || [];

    if (wishlistIds.length === 0) {
        gridContainer.innerHTML = '<p style="grid-column: 1/-1; text-align:center; padding:100px 20px; color:#A3A69C; font-size:0.9rem;">您的收藏清單空空如也...</p>';
        return;
    }

    try {
        // 2. 獲取完整的產品資料庫 (注意路徑：從 wishlist/ 往上一層找)
        const response = await fetch('../flowerData.json');
        const allFlowers = await response.json();

        // 3. 篩選出 ID 存在於收藏清單中的花朵資料
        const wishlistedItems = allFlowers.filter(f => wishlistIds.includes(f.id));

        gridContainer.innerHTML = '';

        wishlistedItems.forEach((item) => {
            // 圖片路徑規則：../image/flower/{image_path}-2.jpg
            const imagePath = `../image/flower/${item.image_path}-2.jpg`;
            const productUrl = `../product/index.html?id=${item.id}`;

            gridContainer.innerHTML += `
                <div class="item">
                    <div class="img-box border-box">
                        <a href="${productUrl}">
                            <img src="${imagePath}" alt="${item.name}" onerror="this.src='../image/default.jpg'">
                        </a>
                        <button class="remove-btn" onclick="removeFromWishlist('${item.id}')">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <div class="info">
                        <div class="main-text">
                            <span class="tag">[${item.series}] ${item.name}</span>
                            <span class="price">NT$ ${item.price.toLocaleString()}</span>
                        </div>
                        <div class="item-actions" style="display: flex; gap: 8px; align-items: center;">
                            <div class="share-wrapper" style="position: relative;">
                                <button class="share-btn-inner" onclick="copyProductLink('${productUrl}', this)">
                                    <i class="fa-solid fa-share-nodes"></i>
                                </button>
                                <span class="tooltip">複製成功！</span>
                            </div>
                            <button class="add-btn" onclick="handleWishlistAddToCart('${item.name}', '${item.price}')">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
        });
    } catch (error) {
        console.error("載入收藏清單失敗:", error);
    }
}

/**
 * 移除收藏功能
 */
function removeFromWishlist(id) {
    let wishlistIds = JSON.parse(localStorage.getItem('myWishlist')) || [];
    wishlistIds = wishlistIds.filter(savedId => savedId !== id);
    localStorage.setItem('myWishlist', JSON.stringify(wishlistIds));
    renderWishlist(); // 重新渲染畫面
}

/**
 * 複製商品連結
 */
function copyProductLink(url, btnElement) {
    const fullUrl = window.location.origin + url.replace('..', '');
    const tempInput = document.createElement('input');
    tempInput.value = fullUrl;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand('copy');
    document.body.removeChild(tempInput);

    const tooltip = btnElement.parentElement.querySelector('.tooltip');
    if (tooltip) {
        tooltip.classList.add('show');
        setTimeout(() => tooltip.classList.remove('show'), 1500);
    }
}

/**
 * 橋接購物車功能 (連動 shoppingCart.js)
 */
function handleWishlistAddToCart(name, price) {
    if (typeof addToCart === "function") {
        addToCart(name, `NT$ ${price}`);
    }
}