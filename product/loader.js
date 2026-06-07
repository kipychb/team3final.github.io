/**
 * 產品頁面自動載入器 - 修正版
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
            updateTextContent(flower);
            initImageCarousel(flower);
            syncHeartStatus(flowerId);

            // 加入購物車按鈕
            const addCartBtn = document.querySelector('.add-cart-btn');
            if (addCartBtn) {
                addCartBtn.onclick = function () {
                    // 1. 獲取數量輸入框的值
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1; // 確保至少為 1

                    if (count > flower.inventory) {
                        alert("你把花買光了，最多" + flower.inventory + "，不要就拉倒。");
                    } else if (typeof addToCart === "function") {
                        for (let i = 0; i < count; i++) {
                            addToCart(flower.name, flower.price);
                        }
                    }

                };
            }

            // 立即購買按鈕
            const buyNowBtn = document.querySelector('.buy-btn');
            if (buyNowBtn) {
                buyNowBtn.onclick = function () {
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1;

                    if (count > flower.inventory) {
                        alert("你把花買光了，最多" + flower.inventory + "，不要就拉倒。");
                    } else if (typeof addToCart === "function") {
                        for (let i = 0; i < count; i++) {
                            addToCart(flower.name, flower.price);
                        }
                        window.location.href = '../payment/index.html';
                    }

                };
            }
        } else {
            console.error("找不到該花朵資料");
        }
    } catch (error) {
        console.error("載入產品失敗:", error);
    }
}

// 初始化商品圖片
function initImageCarousel(flower) {
    const mainBox = document.querySelector('.main-img-box');
    const thumbList = document.querySelector('.thumbnail-list');
    if (!mainBox || !thumbList) return;

    // 清空現有內容
    mainBox.innerHTML = '';
    thumbList.innerHTML = '';

    // 假設每種商品有 2 張圖片
    for (let i = 1; i <= 2; i++) {
        const imgSrc = `../image/flower/${flower.image_path}-${i}.jpg`;
        
        // 建立大圖 (img 標籤)
        const bigImg = document.createElement('img');
        bigImg.src = imgSrc;
        bigImg.classList.add('product-main-image');
        bigImg.style.display = (i === 1) ? 'block' : 'none'; // 預設顯示第一張
        mainBox.appendChild(bigImg);

        // 建立縮圖 (img 標籤)
        const thumb = document.createElement('img');
        thumb.src = imgSrc;
        thumb.classList.add('thumb');
        if (i === 1) thumb.classList.add('active');
        
        // 點擊縮圖切換功能
        thumb.onclick = () => {
            // 切換大圖顯示
            mainBox.querySelectorAll('.product-main-image').forEach((img, idx) => {
                img.style.display = (idx === i - 1) ? 'block' : 'none';
            });
            // 切換縮圖樣式
            thumbList.querySelectorAll('.thumb').forEach(t => t.classList.remove('active'));
            thumb.classList.add('active');
        };
        thumbList.appendChild(thumb);
    }
}

// 更新商品內容
function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        container.querySelector('.name').textContent = flower.name;
        container.querySelector('.series').textContent = "【" + flower.series + "系列】";
        container.querySelector('.price').textContent = "NT$ " + flower.price.toLocaleString();
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
        "<strong>環境控制：</strong><br>避免大力碰撞與潮濕環境。",
        "<strong>水分照護：</strong><br>澆水時需避開花瓣以避免水傷。若花瓣有乾枯泛黃或水傷，可輕輕將該瓣剝除。"
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
}

window.addEventListener('load', () => {
    loadProductDetail();
});