/**
 * 商品生成邏輯
 * 1. 讀取 flowerData.json
 * 2. 根據指定清單篩選商品
 * 3. 遍歷資料並生成 HTML 結構注入到 #product-container
 */

document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('product-container');

    // 在此輸入你想要顯示的商品名稱清單
    const targetProductNames = [
        "摯愛Love in Bloom",
        "半熟戀人Semi-Ripe Romance",
        "如沐陽光Golden Glow"
    ];

    // 取得資料
    fetch('../../flowerData.json')
        .then(response => response.json())
        .then(data => {
            // 根據清單篩選出要顯示的商品
            const filteredProducts = data.filter(item => targetProductNames.includes(item.name));
            renderProducts(filteredProducts);
        })
        .catch(error => {
            console.error('讀取資料失敗:', error);
            if (container) {
                container.innerHTML = '<p>暫時無法載入商品，請稍後再試。</p>';
            }
        });

    /**
     * 生成商品 HTML 的函式
     */
    function renderProducts(products) {
        if (!container) return;

        // 清空容器
        container.innerHTML = '';

        products.forEach(item => {
            // 處理圖片路徑邏輯
            // 根據 JSON 的 is_fresh 決定前綴 F，並抓取編號
            const category = item.image_path.split('/')[0]; // 'fresh' 或 'dried'
            const idNumber = item.image_path.split('/')[1]; // 編號

            let imgPath = "";
            if (item.is_fresh) {
                imgPath = `../../image/F${idNumber}-1.jpg`;
            } else {
                imgPath = `../../image/${idNumber}-1.jpg`;
            }

            // 建立商品 HTML 模板
            const productHTML = `
                <div class="product-item">
                    <div class="img-placeholder border-box">
                        <img src="${imgPath}" alt="${item.name}">
                    </div>
                    <div class="product-info-row">
                        <div class="text-group">
                            <div class="name-with-plus">
                                <span class="prod-tag-name">${item.name}</span>
                                <i class="fa-solid fa-circle-plus add-btn"></i>
                            </div>
                            <span class="prod-price">$${item.price}</span>
                        </div>
                    </div>
                </div>
            `;

            // 插入容器
            container.insertAdjacentHTML('beforeend', productHTML);
        });
    }
});