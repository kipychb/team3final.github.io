/**
 * addWish.js
 * 功能：點擊愛心按鈕，將產品 ID 存入 localStorage (myWishlist)
 */

document.addEventListener('DOMContentLoaded', () => {
    updateHeartIconsStatus();

    document.addEventListener('click', function (e) {
        const heartBtn = e.target.closest('.heart-btn');
        if (!heartBtn) return;

        let productId = "";

        // --- 修正後的抓取邏輯 ---

        // 1. 優先從按鈕本身的 data-id 抓取 (適用於你的新 HTML)
        productId = heartBtn.getAttribute('data-id');

        // 2. 如果按鈕沒寫 data-id，再嘗試原本的邏輯 (適用於 collection.js 生成的結構)
        if (!productId) {
            const itemElement = heartBtn.closest('.item, .product-item');
            if (itemElement) {
                const linkEl = itemElement.querySelector('a');
                const href = linkEl ? linkEl.getAttribute('href') : "";
                if (href && href.includes('?id=')) {
                    productId = new URLSearchParams(href.split('?')[1]).get('id');
                }
            }
        }

        // 3. 如果是產品詳情頁面
        if (!productId) {
            const urlParams = new URLSearchParams(window.location.search);
            productId = urlParams.get('id');
        }

        if (productId) {
            toggleWishlist(productId, heartBtn);
        } else {
            console.warn("無法取得產品 ID，請檢查 data-id 或 URL 結構。");
        }
    });
});

/**
 * 切換收藏狀態 (保持不變)
 */
function toggleWishlist(id, btn) {
    let wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const index = wishlist.indexOf(id);

    if (index === -1) {
        wishlist.push(id);
        showHeartFeedback(btn, true);
    } else {
        wishlist.splice(index, 1);
        showHeartFeedback(btn, false);
    }

    localStorage.setItem('myWishlist', JSON.stringify(wishlist));
}

/**
 * 載入頁面時同步愛心顏色 (修復實作)
 */
function updateHeartIconsStatus() {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const allHearts = document.querySelectorAll('.heart-btn');

    allHearts.forEach(btn => {
        const id = btn.getAttribute('data-id');
        const icon = btn.querySelector('i');
        if (id && wishlist.includes(id)) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = "#c0a080";
        }
    });
}

function showHeartFeedback(btn, isAdded) {
    const icon = btn.querySelector('i');
    btn.style.transition = "transform 0.2s";
    btn.style.transform = "scale(1.3)";

    setTimeout(() => {
        btn.style.transform = "scale(1)";
        if (isAdded) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = "#c0a080";
        } else {
            icon.classList.replace('fa-solid', 'fa-regular');
            icon.style.color = "";
        }
    }, 200);
}

// 檢查 localStorage 並更新愛心 UI
function syncHeartStatus(id) {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const heartBtn = document.querySelector('.heart-btn');

    if (heartBtn) {
        const icon = heartBtn.querySelector('i');
        // 如果 ID 已在收藏清單中
        if (wishlist.includes(id)) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = "#c0a080"; // 設為你設定的主題金色
        } else {
            icon.classList.replace('fa-solid', 'fa-regular');
            icon.style.color = ""; // 恢復原色
        }
    }
}