document.addEventListener('DOMContentLoaded', () => {
    renderCheckout();
});

async function renderCheckout() {
    const cartData = JSON.parse(localStorage.getItem('myCart')) || [];
    const productList = document.querySelector('.product-list');
    
    // 💡 抓取所有需要更新金額的標籤
    const listSubtotal = document.getElementById('list-subtotal'); // 購物清單下方小計
    const subtotalDisplay = document.getElementById('subtotal-val'); // 訂單資訊商品總額
    const totalDisplay = document.getElementById('total-val');       // 最終總額

    if (!productList) return;

    // 💡 修正變數名稱錯誤
    if (cartData.length === 0) {
        productList.innerHTML = '<p style="text-align:center; padding:30px; color:#999;">購物車內目前沒有商品</p>';
        if (listSubtotal) listSubtotal.innerText = `NT$ 0`;
        if (subtotalDisplay) subtotalDisplay.innerText = `NT$ 0`;
        if (totalDisplay) totalDisplay.innerText = `NT$ 0`;
        return;
    }

    let flowerData = [];
    try {
        const response = await fetch('../flowerData.json');
        flowerData = await response.json();
    } catch (error) {
        console.error("無法載入商品資料庫:", error);
    }

    const summary = cartData.reduce((acc, item) => {
        if (!acc[item.name]) {
            const productInfo = flowerData.find(f => f.name === item.name);
            const imgPath = productInfo ? `../assets/images/${productInfo.image_path}.jpg` : 'images/flower1.png';
            
            acc[item.name] = { 
                price: item.price, 
                qty: 0,
                image: imgPath 
            };
        }
        acc[item.name].qty += 1;
        return acc;
    }, {});

    productList.innerHTML = ''; 
    let total = 0;
    
    for (const name in summary) {
        const item = summary[name];
        const itemTotal = item.price * item.qty;
        total += itemTotal;
        
        productList.innerHTML += `
            <div class="product-item">
                <div class="prod-img">
                    <img src="${item.image}" alt="${name}">
                </div>
                <div class="prod-details">
                    <p class="name">${name}</p>
                    <p class="price">NT$ ${item.price.toLocaleString()}</p>
                </div>
                <span class="quantity">X${item.qty}</span>
            </div>`;
    }
    
    // 💡 同步更新所有金額顯示
    const formattedSubtotal = `NT$ ${total.toLocaleString()}`;
    const formattedTotal = `NT$ ${(total + 120).toLocaleString()}`; // 加上 120 運費

    if (listSubtotal) listSubtotal.innerText = formattedSubtotal;
    if (subtotalDisplay) subtotalDisplay.innerText = formattedSubtotal;
    if (totalDisplay) totalDisplay.innerText = formattedTotal;
}

// 💡 修正 submitOrder 函式重複定義的問題
function submitOrder() {
    const nameInput = document.getElementById('order-name');
    const phoneInput = document.getElementById('order-phone');
    
    const name = nameInput ? nameInput.value.trim() : "";
    const phone = phoneInput ? phoneInput.value.trim() : "";

    if (!name || !phone) {
        alert("請完整填寫收件人資訊 ✿");
        return;
    }

    const overlay = document.getElementById('successOverlay');
    if (overlay) {
        overlay.classList.add('active');

        // 清空購物車
        localStorage.removeItem('myCart');

        // 點擊背景關閉邏輯
        overlay.onclick = function(e) {
            if (e.target === overlay) {
                overlay.classList.remove('active');
            }
        }
    }
}