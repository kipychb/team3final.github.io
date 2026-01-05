document.addEventListener("DOMContentLoaded", () => {
    const reviewsList = document.getElementById("reviews-list");

    // 讀取同路徑下的 JSON 檔案
    fetch('reviewData.json')
        .then(response => response.json())
        .then(data => {
            renderReviews(data);
        })
        .catch(error => console.error('無法讀取評價資料:', error));

    function renderReviews(reviews) {
        reviewsList.innerHTML = ""; // 清空現有內容

        reviews.forEach(review => {
            const reviewItem = document.createElement("div");
            reviewItem.classList.add("review-item");

            // 產生星星 HTML 的邏輯
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

            // 組合 HTML 結構
            reviewItem.innerHTML = `
                <div class="review-header">
                    <span class="reviewer-name">${review.name}</span>
                    <div class="review-stars">
                        ${starsHtml}
                    </div>
                </div>
                <p class="review-text">${review.comment}</p>
            `;

            reviewsList.appendChild(reviewItem);
        });
    }
});