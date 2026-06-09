/**
 * loader.js
 * 功能：產品頁面自動載入器 - SQL 資料庫對接版 (修復縮圖切換功能)
 * 說明：串接 get_product_detail.jsp 載入商品，並對接 SQL 購物車與願望清單
 */

async function loadProductDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id'); // 獲取 URL 的 ProductID

    if (!productId) {
        console.error("未找到產品 ID");
        return;
    }

    try {
        // 從 get_product_detail.jsp 撈取特定商品資料
        const response = await fetch(`get_product_detail.jsp?id=${productId}`);
        const flower = await response.json();

        if (flower && flower.ProductID) {
            document.title = `${flower.ProductName} | 花予祝願所`;
            updateTextContent(flower);
            initImageCarousel(flower);

            // 【愛心同步優化】為詳情頁的愛心按鈕設定 data-id，並同步資料庫收藏狀態
            const heartBtn = document.querySelector('.heart-btn');
            if (heartBtn) {
                heartBtn.setAttribute('data-id', flower.ProductID);
            }
            if (typeof syncHeartStatus === "function") {
                syncHeartStatus(flower.ProductID);
            }

            // 綁定「加入購物車」按鈕事件
            const addCartBtn = document.querySelector('.add-cart-btn');
            if (addCartBtn) {
                addCartBtn.onclick = function () {
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1; // 確保至少為 1

                    if (count > flower.Quantity) {
                        alert("你把花買光了，最多 " + flower.Quantity + " 束，不要就拉倒 ✿");
                    } else if (typeof addToCart === "function") {
                        // 【SQL驅動優化】直接呼叫一次 addToCart 並帶入 ProductID 與 選擇數量，不需再跑迴圈
                        addToCart(flower.ProductID, count);
                    } else {
                        console.error("找不到 addToCart 函式，請確認 utils/cart/main.js 已正確載入。");
                    }
                };
            }

            // 綁定「立即購買」按鈕事件
            const buyNowBtn = document.querySelector('.buy-btn');
            if (buyNowBtn) {
                buyNowBtn.onclick = function () {
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1;

                    if (count > flower.Quantity) {
                        alert("你把花買光了，最多 " + flower.Quantity + " 束，不要就拉倒 ✿");
                    } else if (typeof addToCart === "function") {
                        // 1. 同樣改為直接帶入 ID 與數量傳給資料庫
                        addToCart(flower.ProductID, count);
                        // 2. 稍作延遲待購物車更新完畢後跳轉到結帳頁面
                        setTimeout(() => {
                            window.location.href = '../payment/index.jsp';
                        }, 300);
                    } else {
                        console.error("找不到 addToCart 函式，請確認 utils/cart/main.js 已正確載入。");
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

// 初始化商品圖片 (修復 HTML 元素為空，並改為依設計動態生成 2 張主圖與 2 張點擊縮圖)
function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    const thumbList = document.querySelector('.thumbnail-list');
    if (!imgBox) return;

    // 1. 動態生成主視覺大圖 (限制為 2 張)
    imgBox.innerHTML = `
        <img class="carousel-img" src="../image/flower/${flower.Category}/${flower.relativeIndex}-1.jpg" alt="${flower.ProductName}-1" style="display: block; width: 100%; height: 100%; object-fit: cover;">
        <img class="carousel-img" src="../image/flower/${flower.Category}/${flower.relativeIndex}-2.jpg" alt="${flower.ProductName}-2" style="display: none; width: 100%; height: 100%; object-fit: cover;">
    `;

    // 2. 於 .thumbnail-list 動態生成 2 個可點擊的縮圖，並綁定互鎖控制
    if (thumbList) {
        thumbList.innerHTML = `
            <div class="thumb active" data-index="0" style="cursor: pointer;">
                <img src="../image/flower/${flower.Category}/${flower.relativeIndex}-1.jpg" alt="縮圖 1" onerror="this.src='../image/default.jpg'">
            </div>
            <div class="thumb" data-index="1" style="cursor: pointer;">
                <img src="../image/flower/${flower.Category}/${flower.relativeIndex}-2.jpg" alt="縮圖 2" onerror="this.src='../image/default.jpg'">
            </div>
        `;

        const images = imgBox.querySelectorAll('.carousel-img');
        const thumbs = thumbList.querySelectorAll('.thumb');

        thumbs.forEach((thumb, index) => {
            thumb.onclick = () => {
                // 切換主大圖的顯示/隱藏狀態
                images.forEach((img, i) => {
                    if (img) img.style.display = (i === index) ? 'block' : 'none';
                });
                // 更新縮圖外框的 .active 樣式
                thumbs.forEach(t => t.classList.remove('active'));
                thumb.classList.add('active');
            };
        });
    }
}

// 更新商品文字內容
function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        container.querySelector('.name').textContent = flower.ProductName;
        container.querySelector('.series').textContent = "【" + flower.Series + "系列】";
        container.querySelector('.price').textContent = "NT$ " + flower.Price.toLocaleString();
        const descEl = container.querySelector('.desc');
        if (descEl) {
            descEl.style.whiteSpace = "pre-line";
            descEl.textContent = "🕊️花語：" + flower.Language + "\n\n🕊️商品理念：" + flower.Idea;
        }
    }

    const invenEl = document.querySelector('.inventory');
    if (invenEl) invenEl.textContent = "僅剩 " + flower.Quantity + " 束";

    // 細節與配送須知
    const leftBox = document.querySelector('.left-box');
    const rightBox = document.querySelector('.right-box');

    let appreciationPeriod = flower.AppreciationPeriod;

    // 將後端解析出的陣列轉換成條列清單項目
    let methodsHtml = "";
    if (flower.SaveMethods && flower.SaveMethods.length > 0) {
        methodsHtml = flower.SaveMethods.map(m => `<li>${m}</li>`).join('');
    } else {
        methodsHtml = "<li>暫無保存與配送建議資訊。</li>";
    }

    if (leftBox) {
        leftBox.innerHTML = `
            <div><h3>▪️尺寸規格：</h3><p>${flower.Size}</p></div>
            <div><h3>▪️使用花材：</h3><p>${flower.Material}</p></div>
            <div><h3>▪️鑑賞期：</h3><p>${appreciationPeriod}</p></div>
        `;
    }
    if (rightBox) {
        rightBox.innerHTML = `<h3>▪️配送與訂購建議：</h3><ul>${methodsHtml}</ul>`;
    }
}

window.addEventListener('load', () => {
    loadProductDetail();
});