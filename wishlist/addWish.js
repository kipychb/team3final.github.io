/**
 * addWish.js
 * 功能：點擊愛心按鈕，透過 JSP 將產品 ID 與會員 ID 儲存至資料庫的 wishlist table 中
 */

document.addEventListener('DOMContentLoaded', () => {
    updateHeartIconsStatus();

    document.addEventListener('click', function (e) {
        const heartBtn = e.target.closest('.heart-btn');
        if (!heartBtn) return;

        let productId = "";

        // 1. 優先從按鈕本身的 data-id 抓取
        productId = heartBtn.getAttribute('data-id');

        // 2. 如果按鈕沒寫 data-id，則嘗試從父層元素抓取 URL 參數
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

// 自訂非阻斷式 Toast 提示 (共用防錯)
function showToastMessage(message) {
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

/**
 * 切換收藏狀態 (與資料庫對接)
 */
function toggleWishlist(id, btn) {
    // 偵測目前所在的目錄深度，以調整 API 訪問路徑
    let basePath = "";
    if (window.location.pathname.includes('/product/') || window.location.pathname.includes('/series/')) {
        basePath = "../wishlist/";
    } else if (window.location.pathname.includes('/member/')) {
        basePath = "../wishlist/";
    }

    fetch(`${basePath}toggle_wishlist.jsp?product_id=${id}`)
        .then(response => response.text())
        .then(result => {
            const res = result.trim();
            if (res === 'added') {
                showHeartFeedback(btn, true);
                showToastMessage("已加入願望清單 ✿");
            } else if (res === 'removed') {
                showHeartFeedback(btn, false);
                showToastMessage("已從願望清單移除 ✿");
            } else if (res === 'nologin') {
                showToastMessage("此功能僅限會員使用，請先登入帳號 ✿");
                // 延遲跳轉至登入頁
                setTimeout(() => {
                    let loginPath = "member/login/index.jsp";
                    if (window.location.pathname.includes('/product/') || window.location.pathname.includes('/series/') || window.location.pathname.includes('/wishlist/')) {
                        loginPath = "../member/login/index.jsp";
                    }
                    window.location.href = loginPath;
                }, 1000);
            }
        })
        .catch(err => console.error("Wishlist toggle 錯誤:", err));
}

/**
 * 載入頁面時同步愛心顏色 (從 check_wishlist.jsp 取得已收藏列表)
 */
function updateHeartIconsStatus() {
    let basePath = "";
    if (window.location.pathname.includes('/product/') || window.location.pathname.includes('/series/')) {
        basePath = "../wishlist/";
    } else if (window.location.pathname.includes('/member/')) {
        basePath = "../wishlist/";
    }

    fetch(`${basePath}check_wishlist.jsp`)
        .then(response => response.json())
        .then(wishlistIds => {
            const allHearts = document.querySelectorAll('.heart-btn');
            allHearts.forEach(btn => {
                const id = btn.getAttribute('data-id');
                const icon = btn.querySelector('i');
                // 比對資料庫中已收藏的 ProductID
                if (id && wishlistIds.map(Number).includes(Number(id))) {
                    icon.classList.replace('fa-regular', 'fa-solid');
                    icon.style.color = "#c0a080";
                } else {
                    icon.classList.replace('fa-solid', 'fa-regular');
                    icon.style.color = "";
                }
            });
        })
        .catch(err => console.error("Wishlist 同步失敗:", err));
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

// 檢查資料庫並同步更新特定愛心狀態 (產品詳細頁面用)
function syncHeartStatus(id) {
    let basePath = "";
    if (window.location.pathname.includes('/product/') || window.location.pathname.includes('/series/')) {
        basePath = "../wishlist/";
    }

    fetch(`${basePath}check_wishlist.jsp`)
        .then(response => response.json())
        .then(wishlistIds => {
            const heartBtn = document.querySelector('.heart-btn');
            if (heartBtn) {
                const icon = heartBtn.querySelector('i');
                if (wishlistIds.map(Number).includes(Number(id))) {
                    icon.classList.replace('fa-regular', 'fa-solid');
                    icon.style.color = "#c0a080";
                } else {
                    icon.classList.replace('fa-solid', 'fa-regular');
                    icon.style.color = "";
                }
            }
        })
        .catch(err => console.error("單一 Wishlist 同步失敗:", err));
}