document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.querySelector('.search-bar-member input');
    const todayTip = document.querySelector('.today-tip');

    // 儲存原始的「今日祝願花」HTML，以便搜尋清空時還原
    const defaultTipHtml = todayTip.innerHTML;

    let flowerData = [];

    // 取得資料
    fetch('../flowerData.json')
        .then(response => response.json())
        .then(data => {
            flowerData = data;
        })
        .catch(err => console.error("搜尋功能資料載入失敗:", err));

    // 監聽輸入事件
    searchInput.addEventListener('input', function () {
        const keyword = this.value.trim().toLowerCase();

        // 如果搜尋框是空的，還原成原本的今日祝願花
        if (keyword === '') {
            todayTip.innerHTML = defaultTipHtml;
            return;
        }

        // 篩選符合名稱的花卉
        const results = flowerData.filter(flower =>
            flower.name.toLowerCase().includes(keyword)
        );

        // 渲染結果
        renderSearchResults(results);
    });

    function renderSearchResults(results) {
        if (results.length === 0) {
            todayTip.innerHTML = `
            <div class="result-item">
                <div class="right-box">
                    <h4>未找到相關花卉</h4>
                    <p>試試看其他關鍵字吧！</p>
                </div>
            </div>
            ` + defaultTipHtml;
            return;
        }

        // 生成搜尋結果的 HTML
        const resultsHtml = results.map(flower => `
            <div class="result-item" style="margin-bottom: 15px; border-bottom: 1px dashed #ccc; padding-bottom: 10px;">
                <img class="left-box" src='../image/flower/${flower.image_path}-2.jpg'></img>
                <div class="right-box">
                    <h4>祝願花：${flower.name}</h4>
                    <p>花語：${flower.language}</p>
                </div>
            </div>
        `).join('');

        // 將結果插入在原本的內容之前
        todayTip.innerHTML = resultsHtml + defaultTipHtml;
    }
});