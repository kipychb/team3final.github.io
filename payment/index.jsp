<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../utils/config.jsp" %>

<%
    Object midObj=session.getAttribute("mid"); if (midObj==null) {
        response.sendRedirect("../member/login/index.jsp");
        return;
    }
    int memberID=Integer.parseInt(midObj.toString());
%>
            
<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>結帳頁面 | 花予祝願所</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>

<body>

    <header class="navbar">
        <div class="nav-left">
            <a href="javascript:history.back()" class="home-link">
                <i class="fa-solid fa-chevron-left nav-icon"></i>
            </a>
        </div>
        <div class="nav-logo">
            <h3>結帳資料確認</h3>
        </div>
        <div class="nav-right" style="width: 40px;"></div>
    </header>

    <main class="checkout-wrapper">


        <section class="checkout-card">
            <!-- 動態渲染購物車資料 -->
            <div class="product-list" id="checkout-product-list">
                <p style="text-align:center; padding:30px; color:#999; font-family:'Noto Serif TC', serif;">
                    載入購物清單中... ✿</p>
            </div>
            <div class="subtotal-row">小計：<span class="amount" id="list-subtotal">NT$ 0</span></div>
        </section>

        <section class="form-section">
            <h3 class="section-subtitle">顧客資料</h3>
            <div class="input-group">
                <input type="text" id="order-name" placeholder="請輸入姓名" required>
                <input type="tel" id="order-phone" placeholder="聯絡資訊 (手機)" required>
                <textarea id="order-note" placeholder="訂單備註 (選填)" rows="2"></textarea>
            </div>
        </section>

        <section class="form-section">
            <h3 class="section-subtitle">送貨地址及付款方式</h3>
            <div class="input-group">
                <div class="date-input-wrapper">
                    <input type="date" id="order-date" placeholder="請指定送達日期">
                </div>
                <input type="text" id="order-address" placeholder="請輸入送貨地址" required>
                <select id="order-payment" required>
                    <option value="" disabled selected>付款方式 (請選擇)</option>
                    <option value="credit">信用卡 / 金融卡線上支付</option>
                    <option value="transfer">銀行轉帳 (自動對帳)</option>
                    <option value="linepay">LINE Pay 快速結帳</option>
                </select>
            </div>
        </section>

        <section class="form-section">
            <h3 class="section-subtitle">優惠券</h3>
            <div id="birthday-gift-box"></div>
            <div class="input-group">
                <select id="coupon-select">
                    <option value="" data-amount="0">不使用優惠券</option>
                </select>
                <p class="coupon-hint" id="coupon-hint">系統會自動載入您尚未使用的優惠券。</p>
            </div>
        </section>

        

        <section class="form-section">
            <h3 class="section-subtitle">訂單資訊</h3>
            <div class="summary-list">
                <div class="summary-row"><span>商品總額：</span><span id="subtotal-val">NT$ 0</span></div>
                <div class="summary-row"><span>運費總額：</span><span>NT$ 120</span></div>
                <div class="summary-row discount-row"><span>優惠折扣：</span><span id="discount-val">- NT$
                        0</span></div>
                <div class="summary-row total"><span>總額：</span><span id="total-val">NT$ 0</span></div>
            </div>
        </section>

        <div class="submit-area">
            <button class="checkout-btn" onclick="submitOrder()">
                <span>送出訂單</span>
                <i class="fa-solid fa-paper-plane"></i>
            </button>
        </div>

        <!-- 結帳成功彈窗 -->
        <div class="success-overlay" id="successOverlay">
            <div class="success-card">
                <div class="card-flower"><img src="../quiz/image/5.png" alt="祝願之花"></div>

                <div class="card-content">
                    <p>親愛的顧客，您的訂單
                        <strong>
                            <div id="order-id-display">ORD-XXXXXXXX</div>
                        </strong>
                        已建立。
                    </p>
                    <br>
                    <p>每一朵花都承載著您的心意，我們將細心包裝，<br>確保這份祝福完美送達。</p>
                </div>
                <button class="back-home-btn" onclick="location.href='../index.jsp'">回到首頁</button>
                <p class="card-footer">花予祝願所 ❁ 感謝您的信任</p>
            </div>
        </div>
    </main>

    <script src="submit.jsp"></script>
</body>

</html>