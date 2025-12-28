/**
 * 產品頁面自動載入器
 * 功能：根據 URL 參數載入 JSON 中對應的花朵資料
*/

async function loadProductDetail() {
    // 1. 從網址取得參數 (例如 product.html?id=rose)
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
            // 更新網頁標題
            document.title = `${flower.name} | 花予祝願所`;

            // --- 上半部資訊更新 ---
            let Container = document.querySelector('.product-info .info-group');
            if (Container) {
                const nameEl = Container.querySelector('.name');
                const seriesEl = Container.querySelector('.series');
                const priceEl = Container.querySelector('.price');
                const descEl = Container.querySelector('.desc');

                if (nameEl) nameEl.textContent = flower.name;
                if (seriesEl) seriesEl.textContent = "【" + flower.series + "系列】";
                if (priceEl) priceEl.textContent = "$" + flower.price;

                if (descEl) {
                    descEl.style.whiteSpace = "pre-line";
                    descEl.textContent = "🕊️花語：" + flower.language + "\n🕊️商品理念：" + flower.idea;
                }
            }

            // 更新庫存
            Container = document.querySelector('.product-info .action-bar .quantity');
            if (Container) {
                const invenEl = Container.querySelector('.inventory');
                if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";
            }

            // --- 商品細項 (Bottom Details) 更新 ---
            const detailContainer = document.querySelector('.bottom-details .notice .content-flex');
            if (detailContainer) {
                const leftBox = detailContainer.querySelector('.left-box');
                const rightBox = detailContainer.querySelector('.right-box');

                if (leftBox) {
                    // 更新左側：尺寸、花材、鑑賞期
                    leftBox.innerHTML = `
                        <h3>▪️尺寸規格：</h3>
                        <p>${flower.size}</p>
                        <h3>▪️使用花材：</h3>
                        <p>${flower.material}</p>
                        <h3>▪️鑑賞期：</h3>
                        <p>${flower.appreciation_period}</p>
                    `;
                }

                if (rightBox) {
                    // 更新右側：保存重點 (將陣列轉為 li)
                    const methodsHtml = flower.save_methods.map(method => `<li>${method}</li>`).join('');
                    rightBox.innerHTML = `
                        <h3>▪️保存重點：</h3>
                        <ol>${methodsHtml}</ol>
                    `;
                }
            }

            // 更新主圖
            const mainImg = document.querySelector('.main-img-box img');
            if (mainImg) {
                mainImg.src = flower.image;
                mainImg.alt = flower.name;
            }

        } else {
            console.error("找不到該花朵資料");
        }
    } catch (error) {
        console.error("載入產品失敗:", error);
    }
}

// 頁面載入完成後執行
window.onload = loadProductDetail;

// --- 評分系統互動邏輯 ---

let userScore = 0;

// 監聽星星點擊
document.querySelectorAll('.star-rating-input i').forEach(star => {
    star.addEventListener('click', function() {
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