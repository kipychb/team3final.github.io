/*
 * 搜尋欄控制 (Search Panel)
 * 負責處理搜尋邏輯、隨機推薦以及面板開關
 */

let flowerData = [];
const searchTrigger = document.getElementById('search-trigger');
const searchInput = document.getElementById('searchInput');
const suggestionsList = document.getElementById('search-suggestions');

// 1. 導入資料
async function initSearchData() {
    try {
        // 檢查路徑是否正確 (flowerData.json 是否在同一個資料夾)
        const response = await fetch('flowerData.json');
        flowerData = await response.json();
    } catch (error) {
        console.error("搜尋資料載入失敗，請檢查 flowerData.json 是否存在:", error);
    }
}

// 2. 隨機推薦邏輯
function showRecommendations() {
    if (!suggestionsList) return;
    suggestionsList.innerHTML = "<li style='font-size: 0.9rem; color: #705844; border: none; cursor: default;'>✨ 推薦商品：</li>";

    // 確保有資料才進行推薦
    if (flowerData.length === 0) {
        suggestionsList.innerHTML += "<li>載入中...</li>";
        return;
    }

    const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 7);

    selected.forEach(flower => {
        const li = document.createElement('li');
        li.textContent = flower.name;
        li.onclick = () => window.location.href = "product/index.html?id=" + flower.id;
        suggestionsList.appendChild(li);
    });
}

// 3. 開關搜尋面板
if (searchTrigger) {
    searchTrigger.addEventListener('click', (e) => {
        e.stopPropagation();

        // 確保選單面板關閉
        if (sideMenu) sideMenu.classList.remove('active');

        if (sideSearch) sideSearch.classList.toggle('active');
        if (overlay) overlay.classList.toggle('active');

        if (sideSearch && sideSearch.classList.contains('active')) {
            searchInput.focus();
            if (searchInput.value.trim() === "") {
                showRecommendations();
            }
        }
    });
}

// 4. 即時搜尋監聽
if (searchInput) {
    searchInput.addEventListener('input', function () {
        const query = this.value.trim();
        suggestionsList.innerHTML = "";

        if (query.length > 0) {
            const filtered = flowerData.filter(f => f.name.includes(query));
            if (filtered.length > 0) {
                filtered.forEach(f => {
                    const li = document.createElement('li');
                    li.textContent = f.name;
                    li.onclick = () => window.location.href = "product/index.html?id=" + f.id;
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
initSearchData();