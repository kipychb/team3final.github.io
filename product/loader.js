/**
 * 產品頁面自動載入器 - SQL資料庫新版
 */

async function loadProductDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id'); // 獲取 URL 的 ProductID

    if (!productId) {
        console.error("未找到產品 ID");
        return;
    }

    try {
        // 從新寫好的 get_product_detail.jsp 撈取該特定商品資料
        const response = await fetch(`get_product_detail.jsp?id=${productId}`);
        const flower = await response.json();

        if (flower && flower.ProductID) {
            document.title = `${flower.ProductName} | 花予祝願所`;
            updateTextContent(flower);
            initImageCarousel(flower);
            if (typeof syncHeartStatus === "function") {
                syncHeartStatus(productId);
            }

            // 加入購物車按鈕
            const addCartBtn = document.querySelector('.add-cart-btn');
            if (addCartBtn) {
                addCartBtn.onclick = function () {
                    const quantityInput = document.querySelector('.quantity-row .input');
                    const count = parseInt(quantityInput.value) || 1; // 確保至少為 1

                    if (count > flower.Quantity) {
                        alert("你把花買光了，最多" + flower.Quantity + "，不要就拉倒。");
                    } else if (typeof addToCart === "function") {
                        for (let i = 0; i < count; i++) {
                            addToCart(flower.ProductName, flower.Price);
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

                    if (count > flower.Quantity) {
                        alert("你把花買光了，最多" + flower.Quantity + "，不要就拉倒。");
                    } else if (typeof addToCart === "function") {
                        for (let i = 0; i < count; i++) {
                            addToCart(flower.ProductName, flower.Price);
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

// 初始化商品圖片 (利用計算出的 relativeIndex 與 Category 定位正確圖片)
function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    if (!imgBox) return;

    const images = imgBox.querySelectorAll('img');
    const dots = imgBox.querySelectorAll('.img-dots span');

    images.forEach((img, index) => {
        if (img) {
            // 動態產生對應圖片位置，例如：../image/flower/fresh/1-1.jpg
            img.src = `../image/flower/${flower.Category}/${flower.relativeIndex}-${index + 1}.jpg`;
            img.alt = `${flower.ProductName}-${index + 1}`;
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
            descEl.textContent = "🕊️花語：" + flower.Language + "\n🕊️商品理念：" + flower.Idea;
        }
    }

    const invenEl = document.querySelector('.inventory');
    if (invenEl) invenEl.textContent = "僅剩 " + flower.Quantity + " 束";

    // 細節與配送須知
    const leftBox = document.querySelector('.left-box');
    const rightBox = document.querySelector('.right-box');

    const isFresh = (flower.Category === 'fresh');
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