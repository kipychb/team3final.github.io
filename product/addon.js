/**
 * addon.js
 * 功能：根據當前頁面產品 ID 的系列 (series) 進行相關推薦
 */

function loadAddonDetails() {
    fetch('../flowerData.json')
        .then(response => response.json())
        .then(data => {
            renderRecommendations(data);
        })
        .catch(error => {
            console.error('無法讀取花卉資料:', error);
        });
};

/**
 * 渲染相關推薦商品
 * @param {Array} flowerData 所有的花卉陣列
 */
function renderRecommendations(flowerData) {
    const gridContainer = document.getElementById('addon-grid-container');
    if (!gridContainer) return;

    // 1. 取得當前 URL 的產品 ID
    const urlParams = new URLSearchParams(window.location.search);
    const currentId = urlParams.get('id');

    let selected = [];

    // 2. 找到當前產品，並根據系列篩選
    const currentFlower = flowerData.find(f => f.id === currentId);

    if (currentFlower) {
        // 篩選同系列產品，且排除掉目前顯示的這朵
        const related = flowerData.filter(f => f.series === currentFlower.series && f.id !== currentId);

        // 隨機打亂同系列產品
        selected = related.sort(() => 0.5 - Math.random()).slice(0, 4);
    }

    // 3. 如果同系列不足 4 朵，用其他產品補足 (保底機制)
    if (selected.length < 4) {
        const remainingCount = 4 - selected.length;
        const others = flowerData.filter(f => f.id !== currentId && !selected.includes(f));
        const additional = others.sort(() => 0.5 - Math.random()).slice(0, remainingCount);
        selected = selected.concat(additional);
    }

    // 4. 產生 HTML 字串
    let htmlContent = '';
    selected.forEach(flower => {
        const fullImagePath = `../image/flower/${flower.image_path}-2.jpg`;

        htmlContent += `
            <div class="item">
                <a class="img border-box" href="index.html?id=${flower.id}">
                    <img src="${fullImagePath}" alt="${flower.name}" onerror="this.src='../image/default.jpg'">
                </a>
                <div class="info-row">
                    <div class="text-group">
                        <span class="name">${flower.name}</span>
                        <span class="price">$${flower.price}</span>
                    </div>
                </div>
            </div>
        `;
    });

    gridContainer.innerHTML = htmlContent;
}

// 使用監聽器避免與其他 JS 衝突
window.addEventListener('load', () => {
    loadAddonDetails();
});