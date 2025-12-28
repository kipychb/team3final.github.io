/**
 * 測驗邏輯控制
 * 功能：完成測驗後自動跳轉至對應產品頁面
 */

let quizData = [];

// 測驗結果對應的產品 ID (請確保這些 ID 與 flowerData.json 中的 id 一致)
const resultsMap = {
    "A": { name: "紅玫瑰", product_id: "love_in_bloom" },
    "B": { name: "白百合", product_id: "love_in_bloom" },
    "C": { name: "鬱金香", product_id: "love_in_bloom" },
    "D": { name: "向日葵", product_id: "love_in_bloom" },
    "E": { name: "滿天星", product_id: "love_in_bloom" }
};

let currentStep = 0;
let scoreCounts = { "A": 0, "B": 0, "C": 0, "D": 0, "E": 0 };

// 導入資料
async function initQuiz() {
    try {
        const response = await fetch('quizData.json');
        quizData = await response.json();
        console.log("測驗資料載入成功");
    } catch (error) {
        console.error("載入 quizData.json 失敗:", error);
    }
}

// 開始測驗
function startQuiz() {
    if (quizData.length === 0) {
        console.error("資料尚未載入完成");
        return;
    }
    document.getElementById('coverPage').classList.add('hidden');
    document.getElementById('questionPage').classList.remove('hidden');
    showQuestion();
}

// 顯示題目
function showQuestion() {
    const q = quizData[currentStep];
    const qText = document.getElementById('qText');
    const optionsList = document.getElementById('optionsList');

    if (!qText || !optionsList) return;

    qText.innerText = q.title;
    optionsList.innerHTML = '';

    q.options.forEach(opt => {
        const btn = document.createElement('button');
        btn.className = 'option-btn';
        btn.innerText = opt.text;
        btn.onclick = () => {
            scoreCounts[opt.type]++;
            nextStep();
        };
        optionsList.appendChild(btn);
    });
    updateDots();
}

// 更新進度條
function updateDots() {
    const dotsContainer = document.getElementById('dotsContainer');
    if (!dotsContainer) return;

    dotsContainer.innerHTML = '';
    quizData.forEach((_, i) => {
        const dot = document.createElement('div');
        dot.className = 'dot' + (i === currentStep ? ' active' : '');
        dotsContainer.appendChild(dot);
    });
}

// 下一步
function nextStep() {
    currentStep++;
    if (currentStep < quizData.length) {
        showQuestion();
    } else {
        handleFinalResult();
    }
}

/**
 * 處理最終結果並跳轉
 */
function handleFinalResult() {
    // 找出得分最高的類型
    const winnerType = Object.keys(scoreCounts).reduce((a, b) =>
        scoreCounts[a] > scoreCounts[b] ? a : b
    );

    const resultData = resultsMap[winnerType];

    if (resultData && resultData.product_id) {
        // 跳轉路徑：../ 代表跳出 quiz 資料夾，進入 product 資料夾
        const targetUrl = `../product/index.html?id=${resultData.product_id}`;
        console.log("準備跳轉至:", targetUrl);
        window.location.href = targetUrl;
    } else {
        console.error("找不到對應的產品 ID");
        // 備用方案：如果跳轉失敗，至少顯示個訊息
        alert("測驗完成！即將為您跳轉。");
    }
}

// 確保頁面載入後才初始化
window.addEventListener('DOMContentLoaded', initQuiz);