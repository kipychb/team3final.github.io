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

            Container = document.querySelector('.product-info .action-bar .quantity');
            if (Container) {
                const invenEl = Container.querySelector('.inventory');
                if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";
            }

            // 更新主圖 (主圖通常不在 info 容器內，所以維持原本寫法)
            const mainImg = document.querySelector('.main-img-box img');
            if (mainImg) {
                mainImg.src = flower.image;
                mainImg.alt = flower.name;
            }

            // 更新注意事項 (Notice)
            const noticeText = document.querySelector('.text-block:last-child .content-text');
            if (noticeText && flower.notice) {
                noticeText.textContent = flower.notice;
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