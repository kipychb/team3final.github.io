/*
 * 搜尋欄控制 (Search Panel)
 */

let flowerData = [];
let hrefPrefix = "";

// 1. 導入即時資料庫商品資料
async function initSearchData() {
    try {
        const response = await fetch('get_products.jsp');
        flowerData = await response.json();

        console.log("商品資料：", flowerData);
        console.log("商品數量：", flowerData.length);

    } catch (error) {
        console.error(error);
    }
}

// 2. 顯示推薦與熱門搜尋
function showRecommendations() {
    const suggestionsList = document.getElementById('search-suggestions');
    const searchInput = document.getElementById('searchInput');
    if (!suggestionsList) return;

    const hotKeywords = ["青春", "向日葵", "朋友"];
    suggestionsList.innerHTML = "";

    const hotTitle = document.createElement('li');
    hotTitle.textContent = "近期熱搜：";
    hotTitle.style.cssText = "font-size: 0.9rem; color: #a3a69c; border: none; margin-top: 10px; cursor: default;";
    suggestionsList.appendChild(hotTitle);

    hotKeywords.forEach(keyword => {
        const li = document.createElement('li');
        li.textContent = keyword;
        li.style.color = "#705844";
        li.onclick = (e) => {
            e.stopPropagation();
            searchInput.value = keyword;
            searchInput.dispatchEvent(new Event('input'));
        };
        suggestionsList.appendChild(li);
    });

    const recTitle = document.createElement('li');
    recTitle.textContent = "推薦商品：";
    recTitle.style.cssText = "font-size: 0.9rem; color: #a3a69c; border: none; margin-top: 20px; cursor: default;";
    suggestionsList.appendChild(recTitle);

    if (flowerData.length > 0) {
        const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
        shuffled.slice(0, 5).forEach(flower => {
            const li = document.createElement('li');
            li.textContent = flower.ProductName;
            li.onclick = () => window.location.href = hrefPrefix + "product/index.jsp?id=" + flower.ProductID;
            suggestionsList.appendChild(li);
        });
    }
}

// 初始化綁定
document.addEventListener('DOMContentLoaded', () => {
    initSearchData();

    const searchTrigger = document.getElementById('search-trigger');
    const sideSearch = document.getElementById('side-search');
    const searchInput = document.getElementById('searchInput');
    const overlay = document.querySelector('.overlay');

    // 1. 開關面板邏輯
    if (searchTrigger) {
        searchTrigger.addEventListener('click', (e) => {
            e.stopPropagation();
            sideSearch.classList.toggle('active');
            if (overlay) overlay.classList.toggle('active');

            if (sideSearch.classList.contains('active')) {
                searchInput.focus();
                if (searchInput.value.trim() === "") showRecommendations();
            }
        });
    }

    // 2. 全域點擊監聽 (點擊外部自動關閉)
    document.addEventListener('click', (e) => {
        if (sideSearch && sideSearch.classList.contains('active')) {
            // 如果點擊目標不是搜尋框也不是按鈕，就關閉
            if (!sideSearch.contains(e.target) && e.target !== searchTrigger) {
                sideSearch.classList.remove('active');
                if (overlay) overlay.classList.remove('active');
            }
        }
    });

    // 3. 即時搜尋邏輯
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const query = this.value.trim().toLowerCase();
            const suggestionsList = document.getElementById('search-suggestions');
            suggestionsList.innerHTML = "";

            if (query.length > 0) {
                const filtered = flowerData.filter(f => {
                    const name = (f.ProductName || "").toLowerCase();
                    const language = (f.Language || "").toLowerCase();
                    const idea = (f.Idea || "").toLowerCase();
                    const material = (f.Material || "").toLowerCase();
                    const series = (f.Series || "").toLowerCase();

                    return (
                        name.includes(query) ||
                        language.includes(query) ||
                        idea.includes(query) ||
                        material.includes(query) ||
                        series.includes(query)
                    );
                });

                if (filtered.length > 0) {
                    filtered.forEach(f => {
                        const li = document.createElement('li');
                        li.textContent = f.ProductName;
                        li.onclick = () => window.location.href = hrefPrefix + "product/index.jsp?id=" + f.ProductID;
                        suggestionsList.appendChild(li);
                    });
                } else {
                    suggestionsList.innerHTML = "<li style='cursor: default; padding:10px;'>找不到符合的商品</li>";
                }
            } else {
                showRecommendations();
            }
        });
    }
});