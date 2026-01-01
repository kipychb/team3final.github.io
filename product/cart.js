const productAddBtn = document.querySelector('.add-cart-btn');
if (productAddBtn) {
    // 移除 HTML 標籤上的 onclick="toggleCart()" 以免衝突
    productAddBtn.removeAttribute('onclick');

    productAddBtn.onclick = function () {
        // 綁定購物車按鈕
        const productAddBtn = document.querySelector('.add-cart-btn');
        if (productAddBtn) {
            productAddBtn.onclick = function () {
                if (typeof addToCart === "function") {
                    // 修正：確保價格轉為字串，相容 shoppingCart.js 的 replace 邏輯
                    addToCart(flower.name, flower.price.toString());
                }
            };
        }
    }
}