/**
 * 產品頁面自動載入器
 * 功能：根據 URL 參數載入 JSON 中對應的花朵資料，並處理圖片切換
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

            // 1. 更新文字資訊
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

    container = document.querySelector('.product-info .action-bar .quantity');
    if (container) {
        const invenEl = container.querySelector('.inventory');
        if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";
    }

    // 商品細項
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
}

// 初始化圖片輪播與路徑
function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    if (!imgBox) return;

    const images = imgBox.querySelectorAll('img');
    const dots = imgBox.querySelectorAll('.img-dots span');

    // 自動設定圖片路徑
    images.forEach((img, index) => {
        img.src = `../image/flower/${flower.image_path}-${index + 1}.jpg`;
        img.alt = `${flower.name}-${index + 1}`;
        // 初始狀態：第一張顯示，其他隱藏
        img.style.display = (index === 0) ? 'block' : 'none';
    });

    // 綁定圓點點擊事件
    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => {
            // 1. 切換圖片顯示
            images.forEach((img, i) => {
                img.style.display = (i === index) ? 'block' : 'none';
            });

            // 2. 切換圓點 active 狀態
            dots.forEach(d => d.classList.remove('active'));
            dot.classList.add('active');
        });
    });
}

window.onload = loadProductDetail;