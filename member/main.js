// --- 1. 初始化設定 ---
document.addEventListener('DOMContentLoaded', () => {
    // 讀取已儲存的會員資料
    const fields = ['name', 'birth', 'email', 'phone'];
    fields.forEach(field => {
        const savedValue = localStorage.getItem(`member-${field}`);
        if (savedValue) {
            const displaySpan = document.getElementById(`display-${field}`);
            if (displaySpan) displaySpan.innerText = savedValue;
        }
    });

    // 如果預設是願望清單，先渲染一次
    if (document.getElementById('wishlist').classList.contains('active')) {
        renderMemberWishlist();
    }
});

// --- 2. 切換分頁邏輯 ---
function switchSection(id, element) {
    // 切換選單按鈕樣式
    document.querySelectorAll('.flower-item').forEach(item => item.classList.remove('active'));
    element.classList.add('active');

    // 切換內容區塊
    document.querySelectorAll('.section-block').forEach(block => block.classList.remove('active'));
    const targetBlock = document.getElementById(id);
    if (targetBlock) {
        targetBlock.classList.add('active');
    }

    // 如果切換到願望清單，動態渲染
    if (id === 'wishlist') {
        renderMemberWishlist();
    }
}

// --- 3. 願望清單渲染 ---
function renderMemberWishlist() {
    const wishlist = JSON.parse(localStorage.getItem('myWishlist')) || [];
    const container = document.querySelector('#wishlist .list-container');

    if (!container) return;

    if (wishlist.length === 0) {
        container.innerHTML = '<p style="text-align:center; padding:30px; color:#999; width:100%;">目前沒有收藏的願望 ✿</p>';
        return;
    }

    container.innerHTML = wishlist.map((item, index) => `
        <div class="wish-item-row">
            <div class="wish-text">
                <p class="wish-name">${item.name}</p>
                <p class="wish-price">NT$ ${item.price.toLocaleString()}</p>
            </div>
            <button class="mini-add-btn" onclick="addToCartFromWishlist('${item.name}', ${item.price}, '${item.image}')">
                <i class="fa-solid fa-plus"></i>
            </button>
        </div>
    `).join('');
}

// --- 4. 加入購物車功能 ---
function addToCartFromWishlist(name, price, image) {
    let cart = JSON.parse(localStorage.getItem('myCart')) || [];
    const existingItem = cart.find(item => item.name === name);

    if (existingItem) {
        existingItem.qty += 1;
    } else {
        cart.push({ name, price, image, qty: 1 });
    }

    localStorage.setItem('myCart', JSON.stringify(cart));
    alert(`✿ 「${name}」已加入購物車 ✿`);

    if (typeof updateCartUI === 'function') {
        updateCartUI();
    }
}

// --- 5. 會員資料修改模式 ---
let isEditMode = false;
function toggleEditMode() {
    const editBtn = document.getElementById('edit-btn');
    const fields = [
        { id: 'name', display: 'display-name', input: 'edit-name' },
        { id: 'birth', display: 'display-birth', input: 'edit-birth' },
        { id: 'email', display: 'display-email', input: 'edit-email' },
        { id: 'phone', display: 'display-phone', input: 'edit-phone' }
    ];

    if (!isEditMode) {
        isEditMode = true;
        editBtn.innerText = "儲存修改資料";
        editBtn.classList.add('save-mode');

        fields.forEach(field => {
            const displaySpan = document.getElementById(field.display);
            const inputField = document.getElementById(field.input);
            if (displaySpan && inputField) {
                inputField.value = displaySpan.innerText;
                displaySpan.style.display = 'none';
                inputField.style.display = 'inline-block';
            }
        });
    } else {
        isEditMode = false;
        editBtn.innerText = "修改個人資料";
        editBtn.classList.remove('save-mode');

        fields.forEach(field => {
            const displaySpan = document.getElementById(field.display);
            const inputField = document.getElementById(field.input);
            if (displaySpan && inputField) {
                displaySpan.innerText = inputField.value;
                displaySpan.style.display = 'inline-block';
                inputField.style.display = 'none';
                localStorage.setItem(`member-${field.id}`, inputField.value);
            }
        });
        alert("已為您更新會員資料 ✿");
    }
}

// --- 6. 訂單卡片點擊監聽 (最穩定的事件委託法) ---
document.addEventListener('click', (e) => {
    const card = e.target.closest('.order-card');
    if (card) {
        if (e.target.tagName === 'A') return;
        const itemNameLink = card.querySelector('.item-name');
        if (itemNameLink) {
            window.location.href = itemNameLink.getAttribute('href');
        }
    }
});