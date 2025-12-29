/**
 * 產品頁面自動載入器 - 修正版
*/

// 1. 全域變數統一宣告
let userScore = 0;

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
            updateTextContent(flower);
            initImageCarousel(flower);
        } else {
            console.error("找不到該花朵資料");
        }
    } catch (error) {
        console.error("載入產品失敗:", error);
    }
}

// --- 更新文字內容 ---
function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        container.querySelector('.name').textContent = flower.name;
        container.querySelector('.series').textContent = "【" + flower.series + "系列】";
        container.querySelector('.price').textContent = "$" + flower.price;
        const descEl = container.querySelector('.desc');
        if (descEl) {
            descEl.style.whiteSpace = "pre-line";
            descEl.textContent = "🕊️花語：" + flower.language + "\n🕊️商品理念：" + flower.idea;
        }
    }

    const invenEl = document.querySelector('.inventory');
    if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";

    // 細節與配送須知
    const leftBox = document.querySelector('.left-box');
    const rightBox = document.querySelector('.right-box');

    let appreciationPeriod = flower.is_fresh ? "鮮花保存約 5～7 天" : "良好保存 1 年以上";
    let methods = flower.is_fresh ? [
        "<strong>訂購須知：</strong><br>鮮花受環境影響大，不建議長途配送。",
        "<strong>避光避熱：</strong><br>應放置於通風涼爽處。",
        "<strong>水分照護：</strong><br>需避開花瓣以避免水傷。"
    ] : [
        "<strong>訂購須知：</strong><br>適合遠距離寄送。",
        "<strong>環境控制：</strong><br>務必避免潮濕，防止大力碰撞。"
    ];

    if (leftBox) {
        leftBox.innerHTML = `
            <div><h3>▪️尺寸規格：</h3><p>${flower.size}</p></div>
            <div><h3>▪️使用花材：</h3><p>${flower.material}</p></div>
            <div><h3>▪️鑑賞期：</h3><p>${appreciationPeriod}</p></div>
        `;
    }
    if (rightBox) {
        const methodsHtml = methods.map(m => `<li>${m}</li>`).join('');
        rightBox.innerHTML = `<h3>▪️配送與訂購建議：</h3><ul>${methodsHtml}</ul>`;
    }

    // --- 修正處：綁定加入購物車按鈕 ---
    // 根據您的 HTML，按鈕 class 為 .add-cart-btn
    const productAddBtn = document.querySelector('.add-cart-btn');
    if (productAddBtn) {
        // 移除 HTML 標籤上的 onclick="toggleCart()" 以免衝突
        productAddBtn.removeAttribute('onclick');

        productAddBtn.onclick = function () {
            // 綁定購物車按鈕
            const productAddBtn = document.querySelector('.add-cart-btn');
            if (productAddBtn) {
                productAddBtn.onclick = function () {
                    if (typeof addToCart === "function") {
                        // 修正：確保價格轉為字串，相容 shoppingCart.js 的 replace 邏輯
                        addToCart(flower.name, flower.price.toString());
                    }
                };
            }
        }

        function initImageCarousel(flower) {
            const imgBox = document.querySelector('.main-img-box');
            if (!imgBox) return;

            const images = imgBox.querySelectorAll('img');
            const dots = imgBox.querySelectorAll('.img-dots span');

            images.forEach((img, index) => {
                if (img) {
                    img.src = `../image/flower/${flower.image_path}-${index + 1}.jpg`;
                    img.alt = `${flower.name}-${index + 1}`;
                    img.style.display = (index === 0) ? 'block' : 'none';
                }
            });

            dots.forEach((dot, index) => {
                dot.onclick = () => {
                    images.forEach((img, i) => {
                        if (img) img.style.display = (i === index) ? 'block' : 'none';
                    });
                    dots.forEach(d => d.classList.remove('active'));
                    dot.classList.add('active');
                };
            });
        }
    }
}

// 初始化
window.onload = () => {
    loadProductDetail();
}