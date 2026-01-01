/**
 * addWish.js
 * 功能：點擊愛心按鈕，僅將產品 ID 存入 localStorage (myWishlist)
 */

document.addEventListener('DOMContentLoaded', () => {
    // 頁面載入時，先根據 localStorage 初始化愛心狀態
    updateHeartIconsStatus();

    document.addEventListener('click', function (e) {
        const heartBtn = e.target.closest('.heart-btn');
        if (!heartBtn) return;

        let productId = "";

        // 判斷當前是列表頁還是產品詳情頁來抓取 ID
        const itemElement = heartBtn.closest('.item');
        if (itemElement) {
            // 列表頁：從連結抓取 id
            const linkEl = itemElement.querySelector('.img-box a') || itemElement.querySelector('a');
            const href = linkEl.getAttribute('href');
            productId = new URLSearchParams(href.split('?')[1]).get('id');
        } else {
            // 產品詳情頁：從網址抓取 id
            const urlParams = new URLSearchParams(window.location.search);
            productId = urlParams.get('id');
        }

        if (productId) {
            toggleWishlist(productId, heartBtn);
        }
    });
});

/**
 * 切換收藏狀態
 */
function toggleWishlist(id, btn) {
    let wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const index = wishlist.indexOf(id);

    if (index === -1) {
        // 不在清單中 -> 新增
        wishlist.push(id);
        showHeartFeedback(btn, true);
    } else {
        // 已在清單中 -> 移除
        wishlist.splice(index, 1);
        showHeartFeedback(btn, false);
    }

    localStorage.setItem('myWishlist', JSON.stringify(wishlist));
}

/**
 * 載入頁面時同步愛心顏色
 */
function updateHeartIconsStatus() {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    // 這裡可以根據頁面上的 id 元素來預設愛心是否為實心，
    // 但因為產品頁通常是動態載入，建議在 loader.js 載入完後再呼叫此函數。
}

function showHeartFeedback(btn, isAdded) {
    const icon = btn.querySelector('i');
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