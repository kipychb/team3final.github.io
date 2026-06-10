/**
 * addon.js
 * 功能：根據當前頁面產品 ProductID 的系列 (Series) 進行相關推薦 (已對齊 SQL 資料庫規格並修復破圖)
 */

function loadAddonDetails() {
    // 向對接資料庫的 get_products.jsp 請求即時資料
    fetch('../get_products.jsp')
        .then(response => response.json())
        .then(data => {
            // 1. 在隨機篩選前，依原始順序動態計算每筆商品的 relativeIndex，確保舊圖片路徑正確
            let freshCount = 0;
            let driedCount = 0;
            data.forEach(flower => {
                if (flower.Category === 'fresh') {
                    freshCount++;
                    flower.relativeIndex = freshCount;
                } else {
                    driedCount++;
                    flower.relativeIndex = driedCount;
                }
            });

            // 2. 進行相關推薦的渲染
            renderRecommendations(data);
        })
        .catch(error => {
            console.error('無法讀取花卉資料庫:', error);
        });
};

/**
 * 渲染相關推薦商品
 * @param {Array} flowerData 所有的花卉陣列 (來自資料庫)
 */
function renderRecommendations(flowerData) {
    const gridContainer = document.getElementById('addon-grid-container');
    if (!gridContainer) return;

    // 1. 取得當前 URL 的產品 ID (ProductID)
    const urlParams = new URLSearchParams(window.location.search);
    const currentId = urlParams.get('id') || '1';

    // 2. 找出跟當前商品同系列 (Series) 且非當前瀏覽的商品
    const currentFlower = flowerData.find(f => f.ProductID.toString() === currentId);
    let selected = [];

    if (currentFlower) {
        const related = flowerData.filter(f => f.Series === currentFlower.Series && f.ProductID.toString() !== currentId);
        // 隨機打亂同系列產品
        selected = related.sort(() => 0.5 - Math.random()).slice(0, 4);
    }

    // 3. 如果同系列不足 4 朵，用其他產品補足 (保底機制)
    if (selected.length < 4) {
        const remainingCount = 4 - selected.length;
        const others = flowerData.filter(f => f.ProductID.toString() !== currentId && !selected.includes(f));
        const additional = others.sort(() => 0.5 - Math.random()).slice(0, remainingCount);
        selected = selected.concat(additional);
    }

    // 4. 產生 HTML 字串
    let htmlContent = '';
    selected.forEach(flower => {
        // 💡 萬能保底備用圖
        const fallbackImg = "../image/flower/fresh/1-2.jpg";
        let fullImagePath = "";

        // 💡 關鍵路徑修正：判斷是不是新上傳的 UUID 圖片，讓推薦區塊也能正確看得到新圖！
        if (flower.Image && flower.Image.trim() !== '' && flower.Image.trim() !== 'null') {
            let imgUrl = flower.Image.trim();
            
            // 判斷是否為寫死的舊格式
            if (imgUrl.indexOf('/') !== -1 || imgUrl.endsWith("-2.jpg")) {
                if (imgUrl.indexOf('image/') === 0) {
                    fullImagePath = "../" + imgUrl;
                } else {
                    fullImagePath = "../image/" + imgUrl;
                }
            } else {
                // 新上傳的 UUID 圖片，一律存在 ../image/images/ 內
                fullImagePath = `../image/images/${imgUrl}`;
            }
        } else {
            // 完全沒欄位時的舊流水號路徑
            fullImagePath = `../image/flower/${flower.Category}/${flower.relativeIndex}-2.jpg`;
        }

        htmlContent += `
            <div class="item">
                <a class="img border-box" href="index.jsp?id=${flower.ProductID}">
                    <img src="${fullImagePath}" alt="${flower.ProductName}" onerror="this.onerror=null; this.src='${fallbackImg}';">
                </a>
                <div class="info-row">
                    <div class="text-group">
                        <span class="name">${flower.ProductName}</span>
                        <span class="price">NT$ ${flower.Price.toLocaleString()}</span>
                    </div>
                    <button class="add-btn-circle" onclick="event.stopPropagation(); if(typeof addToCart === 'function'){ addToCart(${flower.ProductID}, 1); }else{ alert('購物車模組尚未載入'); }">
                        <i class="fa-solid fa-plus"></i>
                    </button>
                </div>
            </div>
        `;
    });

    gridContainer.innerHTML = htmlContent;
}

// 供主控端動態呼叫的初始化入口
window.addEventListener('load', () => {
    loadAddonDetails();
}); 