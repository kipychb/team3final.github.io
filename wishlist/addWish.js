/**
 * addWish.js
 * 功能：點擊愛心按鈕將商品加入收藏清單 (myWishlist)
 */

document.addEventListener('DOMContentLoaded', () => {
    // 監聽全域點擊事件
    document.addEventListener('click', function (e) {
        // 檢查是否點擊到愛心按鈕或其圖示
        const heartBtn = e.target.closest('.heart-btn');

        if (heartBtn) {
            const itemElement = heartBtn.closest('.item');
            if (!itemElement) return;

            // 1. 抓取商品資訊
            // 根據你提供的結構：.tag 內含 "名稱<br>[系列]"
            const tagEl = itemElement.querySelector('.tag');
            const priceEl = itemElement.querySelector('.price');
            const imgEl = itemElement.querySelector('.img-box img');
            const linkEl = itemElement.querySelector('.img-box a');

            // 處理名稱與系列 (分離文字)
            const tagHtml = tagEl.innerHTML; // 例如 "慢時Slow Time<br>[For Elders]"
            const name = tagHtml.split('<br>')[0].trim();
            const series = tagHtml.includes('[') ? tagHtml.match(/\[(.*?)\]/)[1] : '';

            // 處理價格 (轉為純數字)
            const price = parseInt(priceEl.innerText.replace(/[^0-9]/g, '')) || 0;

            // 處理圖片路徑與 ID
            // 圖片 src 通常是 "../image/flower/dried/13-2.jpg" -> 我們要存 "dried/13"
            const src = imgEl.getAttribute('src');
            const imagePath = src.replace('../image/flower/', '').replace('-2.jpg', '');

            // 從連結抓取 ID (href="product/index.html?id=slow_time")
            const href = linkEl.getAttribute('href');
            const id = new URLSearchParams(href.split('?')[1]).get('id');

            // 2. 建立商品物件
            const flowerObj = {
                id: id,
                name: name,
                series: series,
                price: price,
                image_path: imagePath
            };

            // 3. 儲存至 localStorage
            addToWishlist(flowerObj, heartBtn);
        }
    });
});

/**
 * 將物件存入 localStorage
 */
function addToWishlist(flower, btn) {
    let wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];

    // 檢查是否已存在
    const isExist = wishlist.find(item => item.id === flower.id);

    if (!isExist) {
        wishlist.push(flower);
        localStorage.setItem('myWishlist', JSON.stringify(wishlist));

        // 成功動畫與回饋
        showHeartFeedback(btn, true);
    } else {
        // 如果已經有了，可以視為取消收藏或提示已存在
        showHeartFeedback(btn, false);
    }
}

/**
 * 按鈕回饋動畫
 */
function showHeartFeedback(btn, isAdded) {
    const icon = btn.querySelector('i');

    // 簡單的縮放動畫
    btn.style.transform = "scale(1.4)";
    setTimeout(() => {
        btn.style.transform = "scale(1)";
        if (isAdded) {
            icon.classList.remove('fa-regular');
            icon.classList.add('fa-solid');
            icon.style.color = "#c0a080"; // 變成主題金色
        }
    }, 200);
}