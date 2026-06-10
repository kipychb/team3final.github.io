/**
 * wishlist.js
 * 功能：讀取資料庫，並根據會員收藏的 ProductID 渲染頁面
 */

document.addEventListener('DOMContentLoaded', () => {
    renderWishlist();
});

// 自訂非阻塞 Toast 提示
function showToast(message) {
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

async function renderWishlist() {
    const gridContainer = document.querySelector('.wishlist-container .grid');
    if (!gridContainer) return;

    try {
        // 1. 直接從 JSP API 獲取當前登入會員的完整收藏列表
        const response = await fetch('get_wishlist.jsp');
        const wishlistedItems = await response.json();

        if (wishlistedItems.length === 0) {
            gridContainer.innerHTML = '<p style="grid-column: 1/-1; text-align:center; padding:100px 20px; color:#A3A69C; font-size:0.9rem;">您的願望清單空空如也...</p>';
            return;
        }

        gridContainer.innerHTML = '';

        wishlistedItems.forEach((item) => {
            // 使用相對排序與分類還原出精準圖片路徑
            const imagePath = `../image/flower/${item.Category}/${item.relativeIndex}-2.jpg`;
            const productUrl = `../product/index.jsp?id=${item.ProductID}`;

            gridContainer.innerHTML += `
                <div class="item">
                    <div class="img-box border-box">
                        <a href="${productUrl}">
                            <img src="${imagePath}" alt="${item.ProductName}" onerror="this.src='../image/default.jpg'">
                        </a>
                        <button class="remove-btn" onclick="removeFromWishlist('${item.ProductID}')">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <div class="info">
                        <div class="main-text">
                            <span class="tag">${item.ProductName}<br>[${item.Series} 系列]</span>
                            <span class="price">NT$ ${item.Price.toLocaleString()}</span>
                        </div>
                        <div class="item-actions" style="display: flex; gap: 8px; align-items: center;">
                            <div class="share-wrapper" style="position: relative;">
                                <button class="share-btn-inner" onclick="copyProductLink('${productUrl}', this)">
                                    <i class="fa-solid fa-share-nodes"></i>
                                </button>
                                <span class="tooltip">複製成功！</span>
                            </div>
                            <button class="add-btn" onclick="handleWishlistAddToCart('${item.ProductName}', ${item.Price})">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
        });
    } catch (error) {
        console.error("載入願望清單失敗:", error);
    }
}

/**
 * 移除收藏功能 (直接操作資料庫)
 */
function removeFromWishlist(productId) {
    fetch(`toggle_wishlist.jsp?product_id=${productId}`)
        .then(response => response.text())
        .then(result => {
            if (result.trim() === 'removed') {
                showToast("已從願望清單中移除 ✿");
                renderWishlist(); // 重新載入並刷屏
            } else if (result.trim() === 'nologin') {
                window.location.href = '../member/login/index.jsp';
            }
        })
        .catch(err => console.error("操作失敗:", err));
}

/**
 * 複製商品連結
 */
function copyProductLink(url, btnElement) {
    // 取得絕對網址，去除可能的相對符號
    const fullUrl = window.location.origin + window.location.pathname.replace('member/index.jsp?tab=wishlist', '') + url.replace('../', '');

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
 * 橋接購物車功能
 */
function handleWishlistAddToCart(name, price) {
    if (typeof addToCart === "function") {
        addToCart(name, price);
        showToast("已為您加入購物車 ✿");
    }
}