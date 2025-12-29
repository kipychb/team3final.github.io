/**
 * 產品頁面自動載入器
 * 功能：根據 URL 參數載入 JSON 中對應的花朵資料，並處理購物車連動與圖片切換
*/

async function loadProductDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const flowerId = urlParams.get('id');

    if (!flowerId) {
        console.error("未找到產品 ID");
        return;
    }

    try {
        const response = await fetch('../flowerData.json');
        const flowerData = await response.json();
        const flower = flowerData.find(f => f.id === flowerId);

        if (flower) {
            document.title = `${flower.name} | 花予祝願所`;

            // 1. 更新文字資訊與綁定購物車按鈕
            updateTextContent(flower);

            // 2. 更新圖片路徑與輪播功能
            initImageCarousel(flower);

        } else {
            console.error("找不到該花朵資料");
        }
    } catch (error) {
        console.error("載入產品失敗:", error);
    }
}

/**
 * 更新頁面文字內容並綁定「加入購物車」按鈕
 */
function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        const nameEl = container.querySelector('.name');
        const seriesEl = container.querySelector('.series');
        const priceEl = container.querySelector('.price');
        const descEl = container.querySelector('.desc');

        if (nameEl) nameEl.textContent = flower.name;
        if (seriesEl) seriesEl.textContent = "【" + flower.series + "系列】";
        if (priceEl) priceEl.textContent = "$" + flower.price;
        if (descEl) {
            descEl.style.whiteSpace = "pre-line";
            descEl.textContent = "🕊️花語：" + flower.language + "\n🕊️商品理念：" + flower.idea;
        }
    }

    // 更新庫存顯示
    const actionContainer = document.querySelector('.product-info .action-bar .quantity');
    if (actionContainer) {
        const invenEl = actionContainer.querySelector('.inventory');
        if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";
    }

    // 商品細項 (尺寸、花材、保存方法)
    const detailContainer = document.querySelector('.bottom-details .notice .content-flex');
    if (detailContainer) {
        const leftBox = detailContainer.querySelector('.left-box');
        const rightBox = detailContainer.querySelector('.right-box');
        if (leftBox) {
            leftBox.innerHTML = `<h3>▪️尺寸規格：</h3><p>${flower.size}</p><h3>▪️使用花材：</h3><p>${flower.material}</p><h3>▪️鑑賞期：</h3><p>${flower.appreciation_period}</p>`;
        }
        if (rightBox) {
            const methodsHtml = flower.save_methods.map(method => `<li>${method}</li>`).join('');
            rightBox.innerHTML = `<h3>▪️保存重點：</h3><ol>${methodsHtml}</ol>`;
        }
    }

    // --- 修正處：綁定加入購物車按鈕 ---
    // 根據您的 HTML，按鈕 class 為 .add-cart-btn
    const productAddBtn = document.querySelector('.add-cart-btn'); 
    if (productAddBtn) {
        // 移除 HTML 標籤上的 onclick="toggleCart()" 以免衝突
        productAddBtn.removeAttribute('onclick'); 
        
        productAddBtn.onclick = function() {
            if (typeof addToCart === "function") {
                // 執行加入動作
                addToCart(flower.name, flower.price);
            } else {
                console.error("未偵測到 addToCart 函數");
            }
        };
    }
}

/**
 * 初始化圖片輪播與路徑
 */
function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    if (!imgBox) return;

    const images = imgBox.querySelectorAll('img');
    const dots = imgBox.querySelectorAll('.img-dots span');

    images.forEach((img, index) => {
        if(img) {
            img.src = `../image/flower/${flower.image_path}-${index + 1}.jpg`;
            img.alt = `${flower.name}-${index + 1}`;
            img.style.display = (index === 0) ? 'block' : 'none';
        }
    });

    dots.forEach((dot, index) => {
        dot.onclick = () => {
            images.forEach((img, i) => {
                if(img) img.style.display = (i === index) ? 'block' : 'none';
            });
            dots.forEach(d => d.classList.remove('active'));
            dot.classList.add('active');
        };
    });
}

// --- 評分系統 ---
let userScore = 0;
document.querySelectorAll('.star-rating-input i').forEach(star => {
    star.addEventListener('click', function() {
        userScore = this.getAttribute('data-value');
        document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
        this.classList.add('selected');
        // 同時點亮前面的星星 (可選)
    });
});

function submitReview() {
    if (userScore === 0) { alert("請先評分"); return; }
    alert("感謝您的評論！");
}

window.onload = loadProductDetail;