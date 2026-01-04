// --- 評分系統 ---

let userScore = 0;

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

// 送出評論函數
function submitReview() {
    const comment = document.getElementById('comment-input').value;

    if (userScore === 0) {
        alert("請先點選星等評分 ✿");
        return;
    }

    // 這裡模擬送出資料，實際開發可連結至後端資料庫
    alert(`感謝您的評論！\n評分：${userScore} 顆星\n內容：${comment || '無'}`);

    // 清空輸入
    document.getElementById('comment-input').value = "";
    document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
    userScore = 0;
}

// 使用監聽器避免與其他 JS 衝突
window.addEventListener('load', () => {
    initStarRating();
});