/*
 * 搜尋欄控制 (Search Panel)
 * 負責處理搜尋邏輯、隨機推薦以及面板開關 (已串接 JSP 資料庫格式)
 */

let flowerData = [];
let hrefPrefix = "";
const searchTrigger = document.getElementById('search-trigger');
const searchInput = document.getElementById('searchInput');
const suggestionsList = document.getElementById('search-suggestions');

// 1. 導入即時資料庫商品資料
async function initSearchData() {
    try {
        const response = await fetch('get_products.jsp');
        flowerData = await response.json();
    } catch (error) {
        try {
            hrefPrefix = "../";
            const response = await fetch('../get_products.jsp');
            flowerData = await response.json();
        } catch (error) {
            console.error("搜尋資料載入失敗，請檢查 get_products.jsp 是否存在:", error);
        }
    }
}

// 2. 隨機推薦邏輯
function showRecommendations() {
    if (!suggestionsList) return;
    suggestionsList.innerHTML = "<li style='font-size: 1rem; color: #705844; border: none; cursor: default;'>推薦商品：</li>";

    // 確保有資料才進行推薦
    if (flowerData.length === 0) {
        suggestionsList.innerHTML += "<li>載入中...</li>";
        return;
    }

    const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 7);

    selected.forEach(flower => {
        const li = document.createElement('li');
        li.textContent = flower.ProductName;
        // 使用新 ProductID 進行導向
        li.onclick = () => window.location.href = hrefPrefix + "product/index.html?id=" + flower.ProductID;
        suggestionsList.appendChild(li);
    });
}

// 3. 開關搜尋面板
if (searchTrigger) {
    searchTrigger.addEventListener('click', (e) => {
        e.stopPropagation();

        // 確保選單面板關閉
        if (typeof sideMenu !== 'undefined' && sideMenu) sideMenu.classList.remove('active');

        if (typeof sideSearch !== 'undefined' && sideSearch) sideSearch.classList.toggle('active');
        if (typeof overlay !== 'undefined' && overlay) overlay.classList.toggle('active');

        if (typeof sideSearch !== 'undefined' && sideSearch && sideSearch.classList.contains('active')) {
            if (searchInput) {
                searchInput.focus();
                if (searchInput.value.trim() === "") {
                    showRecommendations();
                }
            }
        }
    });
}

// 4. 即時搜尋監聽
if (searchInput) {
    searchInput.addEventListener('input', function () {
        const query = this.value.trim().toLowerCase();
        suggestionsList.innerHTML = "";

        if (query.length > 0) {
            // 比對商品名稱
            const filtered = flowerData.filter(f => f.ProductName.toLowerCase().includes(query));
            if (filtered.length > 0) {
                filtered.forEach(f => {
                    const li = document.createElement('li');
                    li.textContent = f.ProductName;
                    // 使用新 ProductID 進行導向
                    li.onclick = () => window.location.href = hrefPrefix + "product/index.html?id=" + f.ProductID;
                    suggestionsList.appendChild(li);
                });
            } else {
                suggestionsList.innerHTML = "<li style='cursor: default;'>無匹配結果</li>";
            }
        } else {
            showRecommendations();
        }
    });
}

// 初始化
window.addEventListener('load', function () {
    initSearchData();
});