
let flowerData = [];
let quizData = [];

// 導入資料
async function initSearchData() {
    try {
        const response = await fetch('../flowerData.json');
        flowerData = await response.json();
    } catch (error) {
        console.error("搜尋資料載入失敗，請檢查 flowerData.json 是否存在:", error);
    }

    try {
        const response = await fetch('quizData.json');
        quizData = await response.json();
    } catch (error) {
        console.error("搜尋資料載入失敗，請檢查 quizData.json 是否存在:", error);
    }
}

const results = {

    "A": { name: "紅玫瑰", language: "熱情、深愛、勇敢的告白", desc: "你擁抱著火焰般的熱烈與勇敢。你的心是直率且充滿愛意的，敢於行動。", image: "image/玫瑰.png", product_id: "love_in_bloom" },

    "B": { name: "白百合", language: "純潔、高雅、心想事成", desc: "你的心境是一片沉靜的高雅淨土。你追求內心的平靜，總是以最簡約的姿態面對生活。", image: "image/百合花.png", product_id: "love_in_bloom" },

    "C": { name: "鬱金香", language: "永恆、典雅、愛的告白", desc: "你擁有內斂而典雅的力量。你不急於展露鋒芒，但內心充滿堅定的原則與秩序感。", image: "image/鬱金香.png", product_id: "love_in_bloom" },

    "D": { name: "黃色洋桔梗", language: "開朗、希望、活潑可愛", desc: "你散發著陽光般積極的光芒。你是天生的樂觀主義者，走到哪裡都能帶來歡笑。", image: "image/桔梗.png.png", product_id: "love_in_bloom" },

    "E": { name: "波斯菊", language: "和諧、自由、少女的真心", desc: "你的靈魂渴望自由。不喜歡被框架束縛，享受在自然中找到的獨特美好。", image: "image/玻斯菊.png", product_id: "love_in_bloom" }

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
    const recommendFlower = flowerData.find(item => item.id === res.product_id);
    document.getElementById('rName').innerText = res.name;
    document.getElementById('rLanguage').innerText = res.language;
    document.getElementById('rDesc').innerText = res.desc;
    document.getElementById('rImage').src = res.image;
    document.getElementById('rProdImg').src = "../image/flower/" + recommendFlower.image_path + "-2.jpg";
    document.getElementById('rProdName').innerText = recommendFlower.name;
    document.getElementById('rProdPrice').innerText = "$" + recommendFlower.price;
    document.getElementById('rProdLink').href = "../product/index.html?id=" + res.product_id;
}

// 初始化
initSearchData();