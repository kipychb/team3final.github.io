//  2. 切換分頁邏輯 
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


    if (id === 'wishlist') {
        renderMemberWishlist();
    }
}

//  3. 願望清單渲染 
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

// 4. 加入購物車功能 
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

//  5. 會員資料修改模式
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
                inputField.value = displaySpan.innerText.trim();
                displaySpan.style.display = 'none';
                inputField.style.display = 'inline-block';
            }
        });
    } else {
        // 抓取各輸入欄位最新的值
        const nameVal = document.getElementById('edit-name').value;
        const birthVal = document.getElementById('edit-birth').value;
        const emailVal = document.getElementById('edit-email').value;
        const phoneVal = document.getElementById('edit-phone').value;

        // 使用 fetch 送出 POST 請求至後端 update_profile.jsp
        fetch('update_profile.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `name=${encodeURIComponent(nameVal)}&birth=${encodeURIComponent(birthVal)}&email=${encodeURIComponent(emailVal)}&phone=${encodeURIComponent(phoneVal)}`
        })
            .then(response => response.text())
            .then(result => {
                if (result.trim() === 'success') {
                    isEditMode = false;
                    editBtn.innerText = "修改個人資料";
                    editBtn.classList.remove('save-mode');

                    // 更新前端畫面上的顯示文字
                    fields.forEach(field => {
                        const displaySpan = document.getElementById(field.display);
                        const inputField = document.getElementById(field.input);
                        if (displaySpan && inputField) {
                            displaySpan.innerText = inputField.value;
                            displaySpan.style.display = 'inline-block';
                            inputField.style.display = 'none';
                        }
                    });
                    alert("已為您更新會員資料!");
                } else if (result.trim() === 'nologin') {
                    alert("登入逾時，請重新登入！");
                } else {
                    alert("資料更新失敗，請檢查輸入內容是否正確！");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("網路異常，無法與伺服器取得連線！");
            });
    }
}

// 6. 訂單卡片點擊監聽 
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

// 7. 登出帳號功能
function logout() {
    window.location.href = 'logout.jsp';
}