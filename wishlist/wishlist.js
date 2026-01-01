/**
 * wishlist.js
 * 功能：從 localStorage 讀取「收藏資料 (myWishlist)」並渲染
 * 更新：加入分享按鈕 (複製連結) 與 圖片跳轉功能
 */

document.addEventListener('DOMContentLoaded', () => {
    renderWishlist();
});

// 1. 渲染收藏清單
function renderWishlist() {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const gridContainer = document.querySelector('.wishlist-container .grid');

    if (!gridContainer) return;

    if (wishlist.length === 0) {
        gridContainer.innerHTML = '<p style="grid-column: 1/-1; text-align:center; padding:100px 20px; color:#A3A69C; font-size:0.9rem;">您的收藏清單空空如也...</p>';
        return;
    }

    gridContainer.innerHTML = '';

    wishlist.forEach((item, index) => {
        const imagePath = `../image/flower/${item.image_path}-2.jpg`;
        const productUrl = `../product/index.html?id=${item.id}`;

        gridContainer.innerHTML += `
            <div class="item">
                <div class="img-box border-box">
                    <!-- 點擊圖片進入商品頁 -->
                    <a href="${productUrl}">
                        <img src="${imagePath}" alt="${item.name}" onerror="this.src='../image/default.jpg'">
                    </a>
                    <button class="remove-btn" onclick="removeFromWishlist(${index})">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
                <div class="info">
                    <div class="main-text">
                        <span class="tag">${item.name}<br>[${item.series}]</span>
                        <span class="price">NT$ ${item.price.toLocaleString()}</span>
                    </div>
                    <div class="item-actions" style="display: flex; gap: 8px;">
                        <!-- 分享按鈕 -->
                        <div class="share-wrapper">
                            <button class="share-btn-inner" onclick="copyProductLink('${productUrl}', this)">
                                <i class="fa-solid fa-share-nodes"></i>
                            </button>
                            <span class="tooltip">複製成功！</span>
                        </div>
                        <!-- 新增按鈕 -->
                        <button class="add-btn" onclick="handleWishlistAddToCart('${item.name}', '${item.price}')">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>
                </div>
            </div>
        `;
    });
}

// 2. 移除收藏
function removeFromWishlist(index) {
    let wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    wishlist.splice(index, 1);
    localStorage.setItem('myWishlist', JSON.stringify(wishlist));
    renderWishlist();
}

// 3. 複製連結功能
function copyProductLink(url, btnElement) {
    // 取得完整網址
    const fullUrl = window.location.origin + url.replace('..', '');

    // 複製到剪貼簿
    const tempInput = document.createElement('input');
    tempInput.value = fullUrl;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand('copy');
    document.body.removeChild(tempInput);

    // 顯示提示訊息 (Tooltip)
    const tooltip = btnElement.parentElement.querySelector('.tooltip');
    if (tooltip) {
        tooltip.classList.add('show');
        setTimeout(() => {
            tooltip.classList.remove('show');
        }, 1500);
    }
}

// 4. 購物車連動
function handleWishlistAddToCart(name, price) {
    const priceTxt = `NT$ ${price}`;
    if (typeof addToCart === "function") {
        addToCart(name, priceTxt);
    } else {
        console.error("找不到 addToCart 函數");
    }
}