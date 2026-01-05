// 全域變數供評分功能使用
let userScore = 0; 

document.addEventListener("DOMContentLoaded", () => {
    // 1. 從 URL 獲取產品 ID (例如: twilight_fantasy)
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id') || 'default_product';

    // 2. 初始化星星點擊事件
    const stars = document.querySelectorAll('.star-rating-input i');
    stars.forEach(star => {
        star.addEventListener('click', function() {
            userScore = parseInt(this.getAttribute('data-value'));
            // 更新星星選取狀態樣式
            stars.forEach(s => s.classList.remove('selected'));
            this.classList.add('selected');
        });
    });

    // 3. 初始載入評價
    loadAndRenderReviews(productId);

    // 將 productId 存在 window 對象，讓 submitReview 也能讀取
    window.currentProductId = productId;
});

// 核心功能：讀取並渲染評價
function loadAndRenderReviews(productId) {
    const reviewsList = document.getElementById("reviews-list");
    
    // 從 localStorage 讀取所有資料 (格式為物件，Key 是 productId)
    let allReviews = JSON.parse(localStorage.getItem('myReviews')) || {};
    
    // 取得當前產品的評價清單，若無則給空陣列
    let currentReviews = allReviews[productId] || [];

    // 若該產品完全沒評價，可以加入一筆預設 Demo 資料 (可選)
    if (currentReviews.length === 0 && productId === "twilight_fantasy") {
        currentReviews = [{
            "name": "系統管理員",
            "stars": 5,
            "comment": "歡迎來到此商品頁面，留下您的第一則評論吧！"
        }];
    }

    reviewsList.innerHTML = ""; // 清空現有內容

    // 渲染每一條評論
    currentReviews.forEach(review => {
        const reviewItem = document.createElement("div");
        reviewItem.classList.add("review-item");

        let starsHtml = "";
        for (let i = 1; i <= 5; i++) {
            if (review.stars >= i) {
                starsHtml += '<i class="fa-solid fa-star"></i>';
            } else if (review.stars >= i - 0.5) {
                starsHtml += '<i class="fa-solid fa-star-half-stroke"></i>';
            } else {
                starsHtml += '<i class="fa-regular fa-star"></i>';
            }
        }

        reviewItem.innerHTML = `
            <div class="review-header">
                <span class="reviewer-name">${review.name}</span>
                <div class="review-stars">${starsHtml}</div>
            </div>
            <p class="review-text">${review.comment}</p>
        `;
        reviewsList.appendChild(reviewItem);
    });
}

// --- 評分系統 ---

// 監聽星星點擊
document.querySelectorAll('.star-rating-input i').forEach(star => {
    star.addEventListener('click', function () {
        userScore = this.getAttribute('data-value');

        // 移除所有選取狀態並重新設定
        const allStars = document.querySelectorAll('.star-rating-input i');
        allStars.forEach(s => s.classList.remove('selected'));
        this.classList.add('selected');

        console.log("用戶評分：", userScore);
    });
});

document.querySelectorAll('.star-rating-input i').forEach(star => {
    star.addEventListener('click', function () {
        userScore = this.getAttribute('data-value');

        document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
        this.classList.add('selected');
    });
});

// --- 評分系統互動邏輯 ---
function initStarRating() {
    const stars = document.querySelectorAll('.star-rating-input i');
    stars.forEach(star => {
        star.addEventListener('click', function () {
            userScore = parseInt(this.getAttribute('data-value'));

            // 修正：點擊時讓目前分度以下的星星都亮起
            stars.forEach(s => {
                const val = parseInt(s.getAttribute('data-value'));
                if (val <= userScore) {
                    s.classList.add('selected');
                } else {
                    s.classList.remove('selected');
                }
            });
            console.log("用戶評分：", userScore);
        });
    });
}

// 修改後的送出評論函數
function submitReview() {
    const commentInput = document.getElementById('comment-input');
    const comment = commentInput.value;
    const productId = window.currentProductId;

    if (userScore === 0) {
        alert("請先點選星等評分 ✿");
        return;
    }

    // 1. 取得現有 localStorage 資料
    let allReviews = JSON.parse(localStorage.getItem('myReviews')) || {};
    let memberName = localStorage.getItem('member-name') || "訪客";
    
    // 2. 確保該 ID 的陣列存在
    if (!allReviews[productId]) {
        allReviews[productId] = [];
    }

    // 3. 建立新評論物件 (這裡匿名處理，或你自己加一個名字欄位)
    const newReview = {
        "name": memberName,
        "stars": userScore,
        "comment": comment || "這則評論沒有留下文字。"
    };

    // 4. 加入陣列 (加在最前面 unshift)
    allReviews[productId].unshift(newReview);

    // 5. 存回 localStorage
    localStorage.setItem('myReviews', JSON.stringify(allReviews));

    // 6. 重新渲染畫面
    loadAndRenderReviews(productId);

    alert(`感謝您的評論！\n評分：${userScore} 顆星\n內容：${comment || '無'}`);

    // 清空輸入欄位
    commentInput.value = "";
    document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
    userScore = 0;
}

window.addEventListener('load', () => {
    initStarRating();
});