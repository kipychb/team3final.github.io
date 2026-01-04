document.addEventListener('DOMContentLoaded', () => {
    renderSimpleWishlist();
});

async function renderSimpleWishlist() {
    const container = document.getElementById('simple-wishlist-container');
    if (!container) return;

    const wishlistIds = JSON.parse(localStorage.getItem('myWishlist')) || [];

    if (wishlistIds.length === 0) {
        container.innerHTML = '<p class="empty-msg">您的願望清單空空如也...</p>';
        return;
    }

    try {
        const response = await fetch('../flowerData.json');
        const allFlowers = await response.json();
        const wishlistedItems = allFlowers.filter(f => wishlistIds.includes(f.id));

        container.innerHTML = '';

        wishlistedItems.forEach(item => {
            const productUrl = `../product/index.html?id=${item.id}`;
            // 圖片路徑使用 image_path 並加上後綴
            const imagePath = `../image/flower/${item.image_path}-2.jpg`;

            const row = document.createElement('div');
            row.className = 'wish-item-row';
            row.innerHTML = `
                <div class="item">
                    <div class="content">
                        <img src="${imagePath}" alt="${item.name}" onerror="this.src=''">
                        <div class="text">
                            <p class="name">${item.name}</p>
                            <p class="price">NT$ ${item.price.toLocaleString()}</p>
                        </div>
                    </div>
                    <div class="actions">
                        <div class="share-wrapper">
                            <button class="mini-btn" onclick="copySimpleLink('${productUrl}', this)">
                                <i class="fa-solid fa-share-nodes"></i>
                            </button>
                            <span class="tooltip">複製成功！</span>
                        </div>
                        <button class="mini-btn" onclick="removeFromSimpleWishlist('${item.id}')">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                </div>
            `;
            container.appendChild(row);
        });
    } catch (error) {
        console.error("載入簡易願望清單失敗:", error);
    }
}

function removeFromSimpleWishlist(id) {
    let wishlistIds = JSON.parse(localStorage.getItem('myWishlist')) || [];
    wishlistIds = wishlistIds.filter(savedId => savedId !== id);
    localStorage.setItem('myWishlist', JSON.stringify(wishlistIds));
    renderSimpleWishlist();
}

function copySimpleLink(url, btnElement) {
    const fullUrl = window.location.origin + url.replace('..', '');
    navigator.clipboard.writeText(fullUrl).then(() => {
        const tooltip = btnElement.parentElement.querySelector('.tooltip');
        if (tooltip) {
            tooltip.classList.add('show');
            setTimeout(() => tooltip.classList.remove('show'), 1500);
        }
    });
}