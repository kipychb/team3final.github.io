<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@include file="../utils/config.jsp" %>
<%
    // 查詢測驗題目
    StringBuilder quizJson = new StringBuilder("[");
    try {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM `quiz` ORDER BY `QuestionID` ASC");
        ResultSet rs = ps.executeQuery();
        boolean firstQ = true;
        while (rs.next()) {
            if (!firstQ) quizJson.append(",");
            firstQ = false;
            String title = rs.getString("Title").replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
            String optA  = rs.getString("OptA").replace("\\", "\\\\").replace("\"", "\\\"");
            String optB  = rs.getString("OptB").replace("\\", "\\\\").replace("\"", "\\\"");
            String optC  = rs.getString("OptC").replace("\\", "\\\\").replace("\"", "\\\"");
            String optD  = rs.getString("OptD").replace("\\", "\\\\").replace("\"", "\\\"");
            String optE  = rs.getString("OptE").replace("\\", "\\\\").replace("\"", "\\\"");
            quizJson.append("{\"title\":\"").append(title).append("\",\"options\":[")
                .append("{\"text\":\"").append(optA).append("\",\"type\":\"A\"},")
                .append("{\"text\":\"").append(optB).append("\",\"type\":\"B\"},")
                .append("{\"text\":\"").append(optC).append("\",\"type\":\"C\"},")
                .append("{\"text\":\"").append(optD).append("\",\"type\":\"D\"},")
                .append("{\"text\":\"").append(optE).append("\",\"type\":\"E\"}")
                .append("]}");
        }
        rs.close(); ps.close();
    } catch (Exception e) { /* DB 失敗時 quizJson 為空陣列 */ }
    quizJson.append("]");

    // 查詢推薦商品（5 個對應 product_id）
    Map<Integer, String[]> productMap = new LinkedHashMap<>();
    try {
        PreparedStatement ps = con.prepareStatement(
            "SELECT `ProductID`, `ProductName`, `Price`, `Image` FROM `product` WHERE `ProductID` IN (1,5,8,9,13)"
        );
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int pid      = rs.getInt("ProductID");
            String pname = rs.getString("ProductName");  if (pname == null) pname = "";
            String price = String.valueOf(rs.getInt("Price"));
            String img   = rs.getString("Image");        if (img == null) img = "";
            // 圖片路徑：-1.jpg 格式取 -2.jpg
            String imgPath;
            if (!img.trim().isEmpty() && img.trim().matches("\\d+-1\\.jpg")) {
                imgPath = "../image/flower/" + img.trim().replace("-1.jpg", "-2.jpg");
            } else if (!img.trim().isEmpty()) {
                imgPath = "../image/flower/" + img.trim();
            } else {
                imgPath = "../image/default.jpg";
            }
            productMap.put(pid, new String[]{ pname.replace("\"","\\\""), price, imgPath });
        }
        rs.close(); ps.close();
    } catch (Exception e) { /* 靜默 */ }
%>
<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>花卉測驗 | 花予祝願所</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>

<body>

    <a href="../index.jsp" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> 返回首頁
    </a>

    <div class="test-container">

        <div id="coverPage" class="page-container">
            <div class="cover-img-box">
                <img src="image/background.jpg" alt="測驗封面">
            </div>
            <div class="cover-text">
                <h2>尋找命定花語</h2>
                <p>兩分鐘找出代表你的花卉</p>
            </div>
            <button class="start-btn" onclick="startQuiz()">開始尋找！</button>
        </div>

        <div id="questionPage" class="page-container hidden">
            <div class="progress-dots" id="dotsContainer"></div>
            <div class="question-text" id="qText"></div>
            <div class="options-list" id="optionsList"></div>
        </div>

        <div id="resultPage" class="result-page hidden">
            <div class="result-header-text">您的命定花卉是 ...</div>

            <div class="result-flex">
                <div class="border-box result-flower-img">
                    <img id="rImage" src="">
                </div>
                <div class="result-flower-info">
                    <div class="info-line"><span>花名：</span><span id="rName"></span></div>
                    <div class="info-line"><span>花語：</span><span id="rLanguage"></span></div>
                    <div class="info">
                        <p id="rDesc"></p>
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="recommend-title">您的推薦商品是 ...</div>
            <div class="recommend-flex">
                <div class="border-box recommend-img">
                    <img id="rProdImg" src="" onerror="this.onerror=null; this.src='../image/default.jpg';">
                </div>
                <div class="result-flower-info">
                    <div class="info-line"><span>商品名稱：</span><br><span id="rProdName"></span></div>
                    <div class="info-line"><span>商品價格：</span><br><span id="rProdPrice"></span></div>
                    <a href="" class="go-btn" id="rProdLink">前往購買</a>
                </div>
            </div>
        </div>

    </div>

    <script>
    // 由 JSP 伺服器端直接嵌入資料，不需要 AJAX fetch
    const quizData = <%= quizJson.toString() %>;

    const productMap = {
<%
    boolean firstP = true;
    for (Map.Entry<Integer, String[]> entry : productMap.entrySet()) {
        if (!firstP) out.print(",\n");
        firstP = false;
        int    pid  = entry.getKey();
        String name = entry.getValue()[0];
        String price = entry.getValue()[1];
        String imgPath = entry.getValue()[2];
%>
        <%= pid %>: { name: "<%= name %>", price: <%= price %>, imgPath: "<%= imgPath %>" }
<%
    }
%>
    };

    const results = {
        "A": { name: "紅玫瑰",  language: "熱情、深愛、勇敢的告白",   desc: "你擁抱著火焰般的熱烈與勇敢。你的心是直率且充滿愛意的，敢於行動。",                   image: "image/1.png", product_id: 1  },
        "B": { name: "白百合",  language: "純潔、高雅、心想事成",     desc: "你的心境是一片沉靜的高雅淨土。你追求內心的平靜，總是以最簡約的姿態面對生活。",           image: "image/2.png", product_id: 8  },
        "C": { name: "鬱金香",  language: "永恆、典雅、愛的告白",     desc: "你擁有內斂而典雅的力量。你不急於展露鋒芒，但內心充滿堅定的原則與秩序感。",             image: "image/3.png", product_id: 9  },
        "D": { name: "洋桔梗",  language: "開朗、希望、活潑可愛",     desc: "你散發著陽光般積極的光芒。你是天生的樂觀主義者，走到哪裡都能帶來歡笑。",               image: "image/4.png", product_id: 5  },
        "E": { name: "波斯菊",  language: "和諧、自由、少女的真心",   desc: "你的靈魂渴望自由。不喜歡被框架束縛，享受在自然中找到的獨特美好。",                     image: "image/5.png", product_id: 13 }
    };

    let step   = 0;
    let counts = { A: 0, B: 0, C: 0, D: 0, E: 0 };

    function startQuiz() {
        document.getElementById('coverPage').classList.add('hidden');
        const qPage = document.getElementById('questionPage');
        qPage.classList.remove('hidden');
        qPage.style.display = 'flex';
        showQuestion();
    }

    function showQuestion() {
        if (!quizData.length) return;
        const q    = quizData[step];
        const list = document.getElementById('optionsList');
        document.getElementById('qText').innerText = q.title;
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
        const qPage = document.getElementById('questionPage');
        qPage.classList.add('hidden');
        qPage.style.display = 'none';
        document.getElementById('resultPage').classList.remove('hidden');

        const win = Object.keys(counts).reduce((a, b) => counts[a] > counts[b] ? a : b);
        const res = results[win];

        document.getElementById('rName').innerText     = res.name;
        document.getElementById('rLanguage').innerText = res.language;
        document.getElementById('rDesc').innerText     = res.desc;
        document.getElementById('rImage').src          = res.image;

        const prod = productMap[res.product_id];
        if (prod) {
            document.getElementById('rProdImg').src        = prod.imgPath;
            document.getElementById('rProdName').innerText = prod.name;
            document.getElementById('rProdPrice').innerText = 'NT$ ' + prod.price.toLocaleString();
            document.getElementById('rProdLink').href       = '../product/index.jsp?id=' + res.product_id;
        }
    }
    </script>
</body>

</html>
