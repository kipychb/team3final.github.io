<%@ page contentType = "text/javascript;charset=utf-8" language = "java" %>

/**
 * search.js
 * 功能：花語搜尋功能 - SQL 資料庫驅動版
 * 說明：從 get_search_products.jsp 獲取即時商品清單與資料庫定義的 Language (花語)
 */
document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.querySelector('.search-bar-member input');
    const todayTip = document.querySelector('.today-tip');

    if (!searchInput || !todayTip) return;

    // 儲存原始的「今日祝願花」HTML，以便搜尋清空時還原
    const defaultTipHtml = todayTip.innerHTML;

    let flowerData = [];

    // 【SQL 驅動】取得資料來源改為 get_search_products.jsp
    fetch('get_search_products.jsp')
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

        // 篩選符合名稱的花卉 (比對資料庫欄位 ProductName 與 Language)
        const results = flowerData.filter(flower =>
            flower.ProductName.toLowerCase().includes(keyword) ||
            flower.Language.toLowerCase().includes(keyword)
        );

        // 渲染結果
        renderSearchResults(results);
    });

    function renderSearchResults(results) {
        if (results.length === 0) {
            todayTip.innerHTML = `
            <div class="result-item">
                <div class="right-box">
                    <h4 class="name">未找到相關花卉 ✿</h4>
                    <p class="language">試試看其他關鍵字吧！</p>
                </div>
            </div>
            ` + defaultTipHtml;
            return;
        }

        const resultsHtml = results.map(flower => {
            const fullImagePath = flowerImg(flower.Image, 1);

            return `
                <div class="result-item">
                    <a href="../product/index.jsp?id=\${flower.ProductID}" style="display: block; width: 60px; height: 60px; flex-shrink: 0;">
                        <img class="left-box" src="\${fullImagePath}" onerror="this.src='../image/default.jpg'" style="width: 100%; height: 100%; border-radius: 2px; object-fit: cover;">
                    </a>
                    <div class="right-box" style="flex: 1;">
                        <h4 class="name">
                            <a href="../product/index.jsp?id=\${flower.ProductID}">
                                祝願花：\${flower.ProductName}
                            </a>
                        </h4>
                        <p class="language">花語：\${flower.Language || "暫無花語介紹 ✿"}</p>
                    </div>
                </div>
            `;
        }).join('');

        // 將結果插入在原本的今日祝願花內容之前
        todayTip.innerHTML = resultsHtml + defaultTipHtml;
    }
});