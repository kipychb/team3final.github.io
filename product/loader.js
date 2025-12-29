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

// --- 評分系統互動邏輯 ---

let userScore = 0;

// 監聽星星點擊
document.querySelectorAll('.star-rating-input i').forEach(star => {
    star.addEventListener('click', function () {
        userScore = this.getAttribute('data-value');

        // 移除所有選取狀態並重新設定
        const allStars = document.querySelectorAll('.star-rating-input i');
        allStars.forEach(s => s.classList.remove('selected'));
        this.classList.add('selected');

        console.log("用戶評分：", userScore);
    });
});

// 送出評論函數
function submitReview() {
    const comment = document.getElementById('comment-input').value;

    if (userScore === 0) {
        alert("請先點選星等評分 ✿");
        return;
    }

    // 這裡模擬送出資料，實際開發可連結至後端資料庫
    alert(`感謝您的評論！\n評分：${userScore} 顆星\n內容：${comment || '無'}`);

    // 清空輸入
    document.getElementById('comment-input').value = "";
    document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
    userScore = 0;
}
// 更新文字內容的函式
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

        // 用 is_fresh 來給事項
        let appreciationPeriod = "";
        let methods = [];
        if (flower.is_fresh == true) {
            appreciationPeriod = "鮮花保存約 5～7 天";
            methods = [
                "<strong>訂購須知：</strong><br>鮮花受環境影響大，不建議長時間常溫物流運送。",
                "<strong>避光避熱：</strong><br>避免陽光直射，應放置於通風涼爽處。",
                "<strong>環境控制：</strong><br>避免大力碰撞與潮濕環境。",
                "<strong>水分照護：</strong><br>澆水時需避開花瓣以避免水傷；若花瓣有乾枯泛黃或水傷，可輕輕將該瓣剝除。",
            ]
        } else {
            appreciationPeriod = "良好保存 1 年以上";
            methods = [
                "<strong>訂購須知：</strong><br>適合遠距離寄送，但需注意防撞包裝。",
                "<strong>環境控制：</strong><br>務必避免潮濕環境，並防止大力碰撞導致碎裂。",
            ]
        }

        if (leftBox) {
            leftBox.innerHTML = `
            <div>
                <h3>▪️尺寸規格：</h3><p>${flower.size}</p>
            </div>
            <div>
                <h3>▪️使用花材：</h3><p>${flower.material}</p>
            </div>
            <div>
                <h3>▪️鑑賞期：</h3><p>${appreciationPeriod}</p>
            </div>
            `;
        }
        if (rightBox) {
            const methodsHtml = methods.map(method => `<li>${method}</li>`).join('');
            rightBox.innerHTML = `<h3>▪️配送與訂購建議：</h3><ul>${methodsHtml}</ul>`;
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

// 頁面載入完成後執行
window.onload = loadProductDetail;
>>>>>>> 9478968a09b7a633542326cc6e0135e51c211c19
