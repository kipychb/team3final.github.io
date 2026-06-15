<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*, java.text.SimpleDateFormat" %>
    <%@include file="../utils/config.jsp" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>會員專屬優惠</title>
            <link rel="stylesheet" href="style.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Euphoria+Script&family=Fugaz+One&family=Homemade+Apple&family=Lavishly+Yours&family=Londrina+Sketch&family=Noto+Sans+TC:wght@100..900&family=Pinyon+Script&family=WindSong:wght@400;500&display=swap"
                rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link rel="stylesheet" href="style.css">
            <style>
                /* 容器：與主站的卡片風格一致 */
                .benefits-container {
                    max-width: 700px;
                    height: 600px;
                    margin: 70px auto 30px auto;
                    padding: 30px;
                    background-color: #f7f3f0;
                    /* 使用主站導覽列背景色 */
                    border: 1px solid #e5e0dc;
                    border-radius: 3px;
                    /* 稍微帶點銳角更顯日系質感 */
                    color: #705844;
                }

                .title {
                    text-align: center;
                    color: #705844;
                    font-family: "Noto Serif TC", serif;
                    font-size: 1.8rem;
                    margin-bottom: 10px;
                }

                .subtitle {
                    text-align: center;
                    color: #A3A69C;
                    font-size: 1rem;
                    margin-bottom: 50px;
                    letter-spacing: 2px;
                }

                /* 優惠項目方塊：改成細緻的暖棕色邊框 */
                .benefit-box {
                    background: transparent;
                    border: 1px solid #c0a080;
                    padding: 30px;
                    margin: 20px 0;
                    border-radius: 3px;
                }

                /* 強調區塊：使用淺棕色背景 */
                .highlight {
                    background: #eeebe2;
                    /* 主站背景紋理色 */
                    padding: 40px;
                    text-align: center;
                    border-radius: 3px;
                    margin: 30px 0;
                }

                h2 {
                    font-weight: 500;
                    margin-bottom: 15px;
                }

                ul {
                    list-style: none;
                    padding-left: 0;
                }

                li {
                    margin: 10px 0;
                    position: relative;
                    padding-left: 20px;
                }

                li::before {
                    content: "⋆˚✿˖°";
                    position: absolute;
                    left: -5px;
                }

                .nav-home {
                    position: absolute;
                    top: 10px;
                    left: 30px;
                    text-decoration: none;
                    color: #705842;
                    font-size: 1.2rem;
                    padding: 8px 16px;
                    transition: 0.3s;
                }

                .coupon-card {
                    background: #bfc1ba;
                    padding: 40px;
                    text-align: center;
                    border-radius: 8px;
                    margin: 25px 0;
                    cursor: pointer;
                    /* 變滑鼠手勢 */
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .coupon-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 20px rgba(212, 160, 23, 0.15);
                }

                .coupon-card:active {
                    transform: translateY(0);
                }

                .price-tag {
                    color: #705844;
                    font-size: 2.2rem;
                    font-weight: bold;
                    display: block;
                    margin-top: 10px;
                }
            </style>
        </head>

        <body style="background:#f8f5f0;">
            <a href="../index.jsp" class="back-home">
                <i class="fa-solid fa-arrow-left"></i> 返回首頁
            </a>

            <div class="benefits-container">
                <h1 class="title">會員專屬優惠</h1>
                <p class="subtitle">感謝您加入花予祝願所，一起享受美好的花禮生活!</p>
                <div class="coupon-card" onclick="claimCoupon()">
                    <h2>即日起新註冊會員</h2>
                    <span class="price-tag" style="color:#7b816c; font-size:2em">點擊領取 $150 元折價券</span>
                </div>

                <div class="benefit-box">
                    <h2>當月壽星專屬禮遇</h2>
                    <p style="font-size:1.2em;">免費升級贈送：</p>
                    <ul style="font-size:1.15em; line-height:2;">
                        <li>「質感霧面透明提袋」一份</li>
                    </ul>
                </div>

            </div>

            <script>
                async function claimCoupon() {
                    // 直接 fetch 同一層目錄的 claim_coupon.jsp
                    const response = await fetch('claim_coupon.jsp');
                    const result = await response.json();

                    alert(result.message);

                    if (result.status === 'success') {
                        const card = document.querySelector('.coupon-card');
                        card.style.opacity = "0.5";
                        card.style.pointerEvents = "none";
                        card.querySelector('.price-tag').textContent = "已領取";
                    }
                }
            </script>

        </body>

        </html>