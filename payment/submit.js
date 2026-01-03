document.addEventListener('DOMContentLoaded', () => {
    renderCheckout();
});

async function renderCheckout() {
    // 1. 讀取購物車資料
    const cartData = JSON.parse(localStorage.getItem('myCart')) || [];
    const productList = document.querySelector('.product-list');
    const subtotalAmount = document.querySelector('.subtotal-row .amount');
    const totalAmount = document.querySelector('.total-row .amount');

    if (!productList) return;

    if (cartData.length === 0) {
        productList.innerHTML = '<p style="text-align:center; padding:30px; color:#999;">購物車內目前沒有商品</p>';
        if (subtotalAmount) subtotalAmount.innerText = `NT$ 0`;
        if (totalAmount) totalAmount.innerText = `NT$ 0`;
        return;
    }

    // --- 新增：取得 flowerData.json 以獲取圖片路徑 ---
    let flowerData = [];
    try {
        // 假設 flowerData.json 在上一層目錄，請依實際路徑調整 (例如 ./flowerData.json)
        const response = await fetch('../flowerData.json');
        flowerData = await response.json();
    } catch (error) {
        console.error("無法載入商品資料庫:", error);
    }

    // 2. 統計商品數量並比對圖片
    const summary = cartData.reduce((acc, item) => {
        if (!acc[item.name]) {
            // 從 JSON 中搜尋同名的商品
            const productInfo = flowerData.find(f => f.name === item.name);
            // 組合圖片路徑，若沒找到則給予預設圖 (假設圖片皆為 .jpg)
            const imgPath = productInfo ? `../assets/images/${productInfo.image_path}.jpg` : '../assets/images/default.jpg';
            
            acc[item.name] = { 
                price: item.price, 
                qty: 0,
                image: imgPath 
            };
        }
        acc[item.name].qty += 1;
        return acc;
    }, {});

    // 3. 渲染頁面
    productList.innerHTML = ''; 
    let total = 0;
    
    for (const name in summary) {
        const item = summary[name];
        const itemTotal = item.price * item.qty;
        total += itemTotal;
        
        // 渲染結構：包含圖片容器
        productList.innerHTML += `
            <div class="product-item">
                <div class="item-info">
                    <img src="${item.image}" alt="${name}" class="checkout-img">
                    <div class="prod-details">
                        <p class="name">${name}</p>
                        <p class="price">NT$ ${item.price.toLocaleString()}</p>
                    </div>
                </div>
                <span class="quantity">X${item.qty}</span>
            </div>`;
    }
    
    // 更新金額顯示
    const formattedTotal = `NT$ ${total.toLocaleString()}`;
    if (subtotalAmount) subtotalAmount.innerText = formattedTotal;
    if (totalAmount) totalAmount.innerText = formattedTotal;
}

// 送出訂單按鈕功能
function submitOrder() {
    const cartData = JSON.parse(localStorage.getItem('myCart')) || [];
    if (cartData.length === 0) {
        alert("您的購物車是空的，無法送出訂單。");
        return;
    }

    const name = document.getElementById('order-name').value.trim();
    const phone = document.getElementById('order-phone').value.trim();

    if (!name || !phone) {
        alert("請完整填寫收件人姓名與電話 ✿");
        return;
    }

    const overlay = document.querySelector('.success-overlay');
    if (overlay) {
        overlay.classList.add('active');
        localStorage.removeItem('myCart');
    }
}