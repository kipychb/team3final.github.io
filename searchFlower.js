// 宣告變數存放資料
let flowerData = [];

// 1. 導入 JSON 資料
async function loadFlowers() {
    try {
        // 請確保你的檔名是 flowers.json
        const response = await fetch('flowerData.json');
        flowerData = await response.json();
    } catch (error) {
        console.error("載入 JSON 失敗:", error);
    }
}

const menuTrigger = document.getElementById('menu-trigger');
const searchTrigger = document.getElementById('search-trigger');
const sideMenu = document.getElementById('side-menu');
const sideSearch = document.getElementById('side-search');
const overlay = document.getElementById('menu-overlay');
const searchInput = document.getElementById('searchInput');
const suggestionsList = document.getElementById('search-suggestions');

// 2. 顯示隨機推薦的函式
function showRecommendations() {
    suggestionsList.innerHTML = "<li style='font-size: 0.9rem; color: #705844; border: none; cursor: default;'>✨ 推薦商品：</li>";

    // 從資料中隨機抓 7 筆
    const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 7);

    selected.forEach(flower => {
        const li = document.createElement('li');
        li.textContent = flower.name;
        li.onclick = () => window.location.href = flower.link;
        suggestionsList.appendChild(li);
    });
}

// 關閉所有面板
function closeAll() {
    sideMenu.classList.remove('active');
    sideSearch.classList.remove('active');
    overlay.classList.remove('active');
}

// 點擊「三條線」：開關選單
menuTrigger.addEventListener('click', (e) => {
    e.stopPropagation();
    sideSearch.classList.remove('active');
    sideMenu.classList.toggle('active');
    overlay.classList.toggle('active');
});

// 點擊「放大鏡」：開關搜尋
searchTrigger.addEventListener('click', (e) => {
    e.stopPropagation();
    sideMenu.classList.remove('active');
    sideSearch.classList.toggle('active');
    overlay.classList.toggle('active');

    if (sideSearch.classList.contains('active')) {
        searchInput.focus();
        // 如果打開時沒打字，顯示推薦
        if (searchInput.value.trim() === "") {
            showRecommendations();
        }
    }
});

// 即時搜尋與推薦監聽
searchInput.addEventListener('input', function () {
    const query = this.value.trim();
    suggestionsList.innerHTML = "";

    if (query.length > 0) {
        // 有打字時：過濾結果
        const filtered = flowerData.filter(f => f.name.includes(query));
        if (filtered.length > 0) {
            filtered.forEach(f => {
                const li = document.createElement('li');
                li.textContent = f.name;
                li.onclick = () => window.location.href = f.link;
                suggestionsList.appendChild(li);
            });
        } else {
            suggestionsList.innerHTML = "<li style='cursor: default;'>無匹配結果</li>";
        }
    } else {
        // 沒打字時：顯示推薦
        showRecommendations();
    }
});

// 點擊遮罩關閉
overlay.addEventListener('click', closeAll);

// 初始化載入
loadFlowers();