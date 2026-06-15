<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../config.jsp" %>
<%
    StringBuilder ids = new StringBuilder("[");
    Object midObj = session.getAttribute("mid");
    if (midObj != null) {
        int memberID = (int) midObj;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement("SELECT `ProductID` FROM `wishlist` WHERE `MemberID` = ?");
            ps.setInt(1, memberID);
            rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) ids.append(",");
                first = false;
                ids.append(rs.getInt("ProductID"));
            }
        } catch (Exception e) {
            // 查詢失敗時保持空陣列
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        }
    }
    ids.append("]");
%>
<script>
/*
 * addWish.jsp — 收藏清單由 JSP 伺服器端注入，免 AJAX 初始化
 */

let dbWishlist = <%= ids.toString() %>;

/**
 * 根據 Image 欄位與需要的變體 (1 或 2) 產生圖片路徑
 * - {N}-1.jpg 格式：有 -1 / -2 兩張，依 variant 選擇
 * - 其他 (UUID 等)：直接使用原始檔名
 * @param {string} image   資料庫 Image 欄位值
 * @param {number} variant 1 或 2
 * @param {string} prefix  路徑前綴，預設 '../'
 */
function flowerImg(image, variant, prefix) {
    prefix = prefix !== undefined ? prefix : '../';
    if (!image || image === 'null' || image.trim() === '') return prefix + 'image/default.jpg';
    const img = image.trim();
    if (/^\d+-1\.jpg$/.test(img)) {
        return prefix + 'image/flower/' + img.replace('-1.jpg', '-' + variant + '.jpg');
    }
    return prefix + 'image/flower/' + img;
}

document.addEventListener('DOMContentLoaded', () => {
    updateHeartIconsStatus();

    document.addEventListener('click', function (e) {
        const heartBtn = e.target.closest('.heart-btn');
        if (!heartBtn) return;

        let productId = heartBtn.getAttribute('data-id');

        if (!productId) {
            const itemEl = heartBtn.closest('.item, .product-item');
            if (itemEl) {
                const linkEl = itemEl.querySelector('a');
                const href = linkEl ? linkEl.getAttribute('href') : '';
                if (href && href.includes('?id=')) {
                    productId = new URLSearchParams(href.split('?')[1]).get('id');
                }
            }
        }

        if (!productId) {
            productId = new URLSearchParams(window.location.search).get('id');
        }

        if (productId) {
            toggleWishlist(productId, heartBtn);
        }
    });
});

function updateHeartIconsStatus() {
    const favoritedIds = dbWishlist.map(Number);
    document.querySelectorAll('.heart-btn').forEach(btn => {
        const id = btn.getAttribute('data-id');
        const icon = btn.querySelector('i');
        if (!icon) return;
        if (id && favoritedIds.includes(Number(id))) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = '#c0a080';
        } else {
            icon.classList.replace('fa-solid', 'fa-regular');
            icon.style.color = '';
        }
    });
}

function toggleWishlist(id, btn) {
    let basePath = 'utils/wishlist/';
    if (window.location.pathname.includes('/product/') ||
        window.location.pathname.includes('/series/') ||
        window.location.pathname.includes('/member/')) {
        basePath = '../utils/wishlist/';
    } else if (window.location.pathname.includes('/utils/wishlist/')) {
        basePath = '';
    }

    fetch(`\${basePath}toggle_wishlist.jsp?product_id=\${id}`)
        .then(r => r.text())
        .then(result => {
            const res = result.trim();
            const numId = Number(id);
            if (res === 'added') {
                showHeartFeedback(btn, true);
                showToastMessage('已加入願望清單 ✿');
                if (!dbWishlist.includes(numId)) dbWishlist.push(numId);
            } else if (res === 'removed') {
                showHeartFeedback(btn, false);
                showToastMessage('已從願望清單移除 ✿');
                dbWishlist = dbWishlist.filter(item => item !== numId);
            } else if (res === 'nologin') {
                showToastMessage('此功能僅限會員使用，請先登入帳號 ✿');
                setTimeout(() => {
                    let loginPath = 'member/login/index.jsp';
                    if (window.location.pathname.includes('/product/') ||
                        window.location.pathname.includes('/series/') ||
                        window.location.pathname.includes('/utils/wishlist/')) {
                        loginPath = '../member/login/index.jsp';
                    }
                    window.location.href = loginPath;
                }, 1000);
            }
        })
        .catch(err => console.error('Wishlist toggle 錯誤:', err));
}

function showHeartFeedback(btn, isAdded) {
    const icon = btn.querySelector('i');
    if (!icon) return;
    btn.style.transition = 'transform 0.2s';
    btn.style.transform = 'scale(1.3)';
    setTimeout(() => {
        btn.style.transform = 'scale(1)';
        if (isAdded) {
            icon.classList.replace('fa-regular', 'fa-solid');
            icon.style.color = '#c0a080';
        } else {
            icon.classList.replace('fa-solid', 'fa-regular');
            icon.style.color = '';
        }
    }, 200);
}

function showToastMessage(message) {
    let toast = document.getElementById('custom-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'custom-toast';
        toast.style.cssText = `
            position:fixed; bottom:30px; left:50%; transform:translateX(-50%);
            background:rgba(112,88,68,0.95); color:#fff; padding:12px 24px;
            border-radius:30px; font-family:'Noto Serif TC',serif;
            box-shadow:0 4px 15px rgba(0,0,0,0.15); z-index:9999;
            transition:opacity 0.3s ease; opacity:0; pointer-events:none; text-align:center;
        `;
        document.body.appendChild(toast);
    }
    toast.innerText = message;
    toast.style.opacity = '1';
    setTimeout(() => { toast.style.opacity = '0'; }, 2000);
}

function handleWishlistAddToCart(name, price) {
    if (typeof addToCart === 'function') {
        addToCart(name, price);
        showToastMessage('已為您加入購物車 ✿');
    }
}

function copyProductLink(url, btnElement) {
    const fullUrl = window.location.origin +
        window.location.pathname.replace('member/index.jsp', '').replace(/\?.*$/, '') +
        url.replace('../', '');
    const tmp = document.createElement('input');
    tmp.value = fullUrl;
    document.body.appendChild(tmp);
    tmp.select();
    document.execCommand('copy');
    document.body.removeChild(tmp);
    const tooltip = btnElement.parentElement.querySelector('.tooltip');
    if (tooltip) {
        tooltip.classList.add('show');
        setTimeout(() => tooltip.classList.remove('show'), 1500);
    }
}
</script>
