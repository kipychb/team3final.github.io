/**
 * addon.js
 * 功能：從 flowerData.json 隨機挑選 4 朵花並顯示在頁面上
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
 * 渲染推薦商品到 HTML
 * @param {Array} flowerData 所有的花卉陣列
 */
function renderRecommendations(flowerData) {
    const gridContainer = document.getElementById('addon-grid-container');
    if (!gridContainer) return;

    // 2. 隨機排序並挑選前 4 個
    // 使用 slice() 避免更動到原始資料
    const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 4);

    // 3. 產生 HTML 字串
    let htmlContent = '';

    selected.forEach(flower => {
        // 根據你的 HTML 範例：圖片路徑規則為 ../image/flower/{image_path}-2.jpg
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

    // 4. 塞入容器
    gridContainer.innerHTML = htmlContent;
}

window.addEventListener('load', () => {
    loadAddonDetails();
});