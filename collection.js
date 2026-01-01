/**
 * collection.js
 * 功能：根據 is_fresh 分類隨機推薦花卉
 */

window.addEventListener('load', function () {
    fetch('flowerData.json')
        .then(response => response.json())
        .then(data => {
            // 分類資料
            const freshFlowers = data.filter(f => f.is_fresh === true);
            const driedFlowers = data.filter(f => f.is_fresh === false);

            // 渲染鮮花 (3x2 網格，挑 6 個)
            renderFlowerGrid(freshFlowers, '.fresh-flower', 6);

            // 渲染乾燥花 (2x3 網格，挑 6 個)
            renderFlowerGrid(driedFlowers, '.dried-flower', 6);
        })
        .catch(err => console.error("資料載入失敗:", err));
});

function renderFlowerGrid(list, selector, count) {
    const container = document.querySelector(selector);
    if (!container) return;

    // 隨機選取
    const shuffled = [...list].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, count);

    let html = '';
    selected.forEach(flower => {
        const imagePath = `../image/flower/${flower.image_path}-2.jpg`;

        html += `
            <div class="item">
                <div class="img-box">
                    <a href="index.html?id=${flower.id}">
                        <img src="${imagePath}" alt="${flower.name}" onerror="this.src='../image/default.jpg'">
                    </a>
                </div>
                <div class="item-info">
                    <div class="info-top">
                        <span class="tag">${flower.name}<br>[${flower.series}]</span>
                        <div class="item-actions">
                            <button class="action-btn-circle heart-btn"><i class="fa-regular fa-heart"></i></button>
                            <button class="add-btn-circle"><i class="fa-solid fa-plus"></i></button>
                        </div>
                    </div>
                    <span class="price">$${flower.price}</span>
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}