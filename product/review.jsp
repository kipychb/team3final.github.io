<%@page contentType="text/javascript;charset=utf-8" language="java" %>

// 全域變數供評分功能使用
let userScore = 0;

document.addEventListener("DOMContentLoaded", () => {
    // 1. 從 URL 獲取產品 ID (例如: 1, 2)
    const urlParams = new URLSearchParams(window.location.search);
    const productId = urlParams.get('id') || '1';

    // 2. 初始載入評價與星星
    loadAndRenderReviews(productId);

    // 將 productId 存在 window 物件，讓 submitReview 也能讀取
    window.currentProductId = productId;

    // 3. 初始化星星點擊事件
    initStarRating();
});

// 建立自訂非阻塞 Toast 提示（取代 alert()）
function showToast(message) {
    let toast = document.getElementById('custom-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'custom-toast';
        toast.style.cssText = `
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(112, 88, 68, 0.95);
            color: #fff;
            padding: 12px 24px;
            border-radius: 30px;
            font-family: 'Noto Serif TC', serif;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            z-index: 9999;
            transition: opacity 0.3s ease;
            opacity: 0;
            pointer-events: none;
            text-align: center;
        `;
        document.body.appendChild(toast);
    }
    toast.innerText = message;
    toast.style.opacity = '1';
    setTimeout(() => {
        toast.style.opacity = '0';
    }, 3000);
}

// 核心功能：讀取並渲染評價 (從 get_reviews.jsp)
function loadAndRenderReviews(productId) {
    const reviewsList = document.getElementById("reviews-list");
    if (!reviewsList) return;

    fetch(`get_reviews.jsp?product_id=\${productId}`)
        .then(response => response.json())
        .then(data => {
            // 更新頁面頂部的平均分數與星星顯示
            const ratingScoreEl = document.getElementById("rating-score");
            if (ratingScoreEl) {
                ratingScoreEl.innerText = data.average.toFixed(1);
            }

            const mainStarsEl = document.getElementById("main-stars");
            if (mainStarsEl) {
                let mainStarsHtml = "";
                const avg = data.average;
                for (let i = 1; i <= 5; i++) {
                    if (avg >= i) {
                        mainStarsHtml += '<i class="fa-solid fa-star"></i>';
                    } else if (avg >= i - 0.5) {
                        mainStarsHtml += '<i class="fa-solid fa-star-half-stroke"></i>';
                    } else {
                        mainStarsHtml += '<i class="fa-regular fa-star"></i>';
                    }
                }
                mainStarsEl.innerHTML = mainStarsHtml;
            }

            reviewsList.innerHTML = "";

            if (data.reviews.length === 0) {
                reviewsList.innerHTML = "<p class='empty-msg' style='text-align:center;color:#999;padding:20px;'>此商品目前還沒有評價，歡迎留下您的第一則評論 ✿</p>";
                return;
            }

            // 渲染每一條評論
            data.reviews.forEach(review => {
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
                        <div class="reviewer-info">
                        <span class="reviewer-name">\${review.name}</span>
                        <span class="review-date">\${review.datetime}</span>
                        </div>
                        <div class="review-stars">\${starsHtml}</div>
                    </div>
                    <p class="review-text">\${review.comment}</p>
                `;
                reviewsList.appendChild(reviewItem);
            });
        })
        .catch(err => {
            console.error("無法加載評價:", err);
            reviewsList.innerHTML = "<p style='text-align:center;color:#999;'>評價載入失敗，請確認資料庫狀態 ✿</p>";
        });
}

// 評分系統互動邏輯
function initStarRating() {
    const stars = document.querySelectorAll('.star-rating-input i');
    stars.forEach(star => {
        star.addEventListener('click', function () {
            userScore = parseInt(this.getAttribute('data-value'));

            // 讓選取星等以下（包含自己）的星星亮起，以上的熄滅
            stars.forEach(s => {
                const val = parseInt(s.getAttribute('data-value'));
                if (val <= userScore) {
                    s.classList.add('selected');
                } else {
                    s.classList.remove('selected');
                }
            });
        });
    });
}

// 送出評論
function submitReview() {
    const commentInput = document.getElementById('comment-input');
    const comment = commentInput.value.trim();
    const productId = window.currentProductId;

    if (userScore === 0) {
        showToast("請先點選星等評分 ✿");
        return;
    }

    const payload = `product_id=\${encodeURIComponent(productId)}&rating=\${userScore}&contents=\${encodeURIComponent(comment || "這則評論沒有留下文字。")}`;

    // 向 add_review.jsp 送出 POST 請求
    fetch('add_review.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: payload
    })
        .then(response => response.text())
        .then(result => {
            // 輸出 Debug 資訊，方便您在 F12 視窗排查錯誤
            console.log("[Debug] add_review.jsp 原始回傳字串為:", JSON.stringify(result));

            const res = result.trim();

            // 使用 includes 進行更寬鬆、安全的配對，防止 JSP 空白字元干擾
            if (res.includes('success')) {
                showToast(`感謝您的評論！\n評分：\${userScore} 顆星`);

                // 重新載入最新評價（會自動更新平均分與星星）
                loadAndRenderReviews(productId);

                // 清空輸入欄位
                commentInput.value = "";
                document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
                userScore = 0;
            } else if (res.includes('nologin')) {
                showToast("此功能僅限會員使用，請先登入帳號 ✿");
            } else {
                // 自動擷取回傳的前 50 個字元，讓您知道資料庫是不是報錯（例如欄位對不上或 SQL 語法錯誤）
                const errorMsg = res.substring(0, 50);
                showToast(`送出失敗 (\${errorMsg})，請確認輸入內容後再試 ✿`);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast("連線異常，無法送出評價！");
        });
}