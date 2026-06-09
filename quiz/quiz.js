let flowerData = [];
let quizData = [];

// 導入即時資料庫資料
async function initSearchData() {
    try {
        // 從資料庫 API 載入最新商品
        const response = await fetch('../get_products.jsp');
        flowerData = await response.json();

        // 在隨機打亂前，先依據原始順序為每一筆資料動態計算好圖片路徑
        let freshCount = 0;
        let driedCount = 0;
        flowerData.forEach(flower => {
            if (flower.Category === 'fresh') {
                freshCount++;
                flower.imagePath = `../image/flower/fresh/${freshCount}-2.jpg`;
            } else {
                driedCount++;
                flower.imagePath = `../image/flower/dried/${driedCount}-2.jpg`;
            }
        });
    } catch (error) {
        console.error("商品資料載入失敗，請檢查 get_products.jsp 是否存在:", error);
    }

    try {
        // 從資料庫 API 載入測驗題目
        const response = await fetch('get_quiz.jsp');
        quizData = await response.json();
    } catch (error) {
        console.error("測驗題目載入失敗，請檢查 get_quiz.jsp 是否存在:", error);
    }
}

// 測驗結果對應表 (product_id 已全面對齊資料庫新 ProductID)
const results = {
    "A": { name: "紅玫瑰", language: "熱情、深愛、勇敢的告白", desc: "你擁抱著火焰般的熱烈與勇敢。你的心是直率且充滿愛意的，敢於行動。", image: "image/1.png", product_id: 1 }, // 摯愛
    "B": { name: "白百合", language: "純潔、高雅、心想事成", desc: "你的心境是一片沉靜的高雅淨土。你追求內心的平靜，總是以最簡約的姿態面對生活。", image: "image/2.png", product_id: 8 }, // 留白時刻
    "C": { name: "鬱金香", language: "永恆、典雅、愛的告白", desc: "你擁有內斂而典雅的力量。你不急於展露鋒芒，但內心充滿堅定的原則與秩序感。", image: "image/3.png", product_id: 9 }, // 沿途拾光
    "D": { name: "洋桔梗", language: "開朗、希望、活潑可愛", desc: "你散發著陽光般積極的光芒。你是天生的樂觀主義者，走到哪裡都能帶來歡笑。", image: "image/4.png", product_id: 5 }, // 微光詩意
    "E": { name: "波斯菊", language: "和諧、自由、少女的真心", desc: "你的靈魂渴望自由。不喜歡被框架束縛，享受在自然中找到的獨特美好。", image: "image/5.png", product_id: 13 } // 歲月靜好
};

let step = 0;
let counts = { A: 0, B: 0, C: 0, D: 0, E: 0 };

function startQuiz() {
    document.getElementById('coverPage').classList.add('hidden');
    document.getElementById('questionPage').classList.remove('hidden');
    document.getElementById('questionPage').style.display = 'flex';
    showQuestion();
}

function showQuestion() {
    if (quizData.length === 0) return;
    const q = quizData[step];
    document.getElementById('qText').innerText = q.title;
    const list = document.getElementById('optionsList');
    list.innerHTML = '';
    q.options.forEach(opt => {
        const btn = document.createElement('button');
        btn.className = 'option-btn';
        btn.innerText = opt.text;
        btn.onclick = () => { counts[opt.type]++; nextStep(); };
        list.appendChild(btn);
    });
    updateDots();
}

function updateDots() {
    const dots = document.getElementById('dotsContainer');
    dots.innerHTML = '';
    quizData.forEach((_, i) => {
        const d = document.createElement('div');
        d.className = 'dot' + (i === step ? ' active' : '');
        dots.appendChild(d);
    });
}

function nextStep() {
    step++;
    if (step < quizData.length) showQuestion();
    else showResult();
}

function showResult() {
    document.getElementById('questionPage').classList.add('hidden');
    document.getElementById('questionPage').style.display = 'none';
    document.getElementById('resultPage').classList.remove('hidden');

    const win = Object.keys(counts).reduce((a, b) => counts[a] > counts[b] ? a : b);
    const res = results[win];

    // 從商品資料庫中尋找對應推薦商品
    const recommendFlower = flowerData.find(item => item.ProductID === res.product_id);

    document.getElementById('rName').innerText = res.name;
    document.getElementById('rLanguage').innerText = res.language;
    document.getElementById('rDesc').innerText = res.desc;
    document.getElementById('rImage').src = res.image;

    if (recommendFlower) {
        document.getElementById('rProdImg').src = recommendFlower.imagePath;
        document.getElementById('rProdName').innerText = recommendFlower.ProductName;
        document.getElementById('rProdPrice').innerText = "$" + recommendFlower.Price;
        document.getElementById('rProdLink').href = "../product/index.jsp?id=" + res.product_id;
    }
}

// 初始化
initSearchData();