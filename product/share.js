
document.addEventListener('DOMContentLoaded', () => {
    const shareBtn = document.getElementById('share-btn');
    const copyToast = document.getElementById('copy-toast');

    shareBtn.addEventListener('click', () => {
        // 1. 獲取目前網址
        const currentUrl = window.location.href;

        // 2. 執行複製動作 (相容性較佳的方法)
        const textArea = document.createElement("textarea");
        textArea.value = currentUrl;
        document.body.appendChild(textArea);
        textArea.select();

        try {
            document.execCommand('copy');

            // 3. 顯示提示訊息
            showToast();
        } catch (err) {
            console.error('無法複製連結', err);
        }

        document.body.removeChild(textArea);
    });

    function showToast() {
        // 避免重複點擊導致計時器衝突，先移除 show 類別
        copyToast.classList.remove('show');

        // 強制瀏覽器重繪
        void copyToast.offsetWidth;

        // 顯示提示
        copyToast.classList.add('show');

        // 2秒後自動消失
        setTimeout(() => {
            copyToast.classList.remove('show');
        }, 2000);
    }
});