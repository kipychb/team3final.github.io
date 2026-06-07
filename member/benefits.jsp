<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ include file="../utils/config.jsp" %>
<%
    // 正確的登入頁面路徑
    if (session.getAttribute("email") == null) {
        response.sendRedirect("../member/login/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>會員專屬優惠 | 花語花店</title>
    <link rel="stylesheet" href="../style.css">
    <style>
        .benefits-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 40px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .title {
            text-align: center;
            color: #705844;
            font-size: 2.4em;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #A3A69C;
            font-size: 1.3em;
            margin-bottom: 40px;
        }
        .benefit-box {
            background: #fff8f0;
            border-left: 6px solid #ffd700;
            padding: 25px;
            margin: 25px 0;
            border-radius: 8px;
        }
        .highlight {
            background: #f8f0e8;
            padding: 30px;
            text-align: center;
            border-radius: 12px;
            margin: 30px 0;
        }
    </style>
</head>
<body style="background:#f8f5f0;">

    <div class="benefits-container">
        <h1 class="title">🌸 會員專屬優惠</h1>
        <p class="subtitle">感謝您加入花語花店，一起享受美好的花禮生活</p>

        <div class="highlight">
            <h2>🎁 即日起新註冊會員</h2>
            <h3 style="color:#d4a017; font-size:2em;">享 $150 元折價券 一張</h3>
        </div>

        <div class="benefit-box">
            <h2>🎂 當月壽星專屬禮遇</h2>
            <p style="font-size:1.2em;">免費升級贈送：</p>
            <ul style="font-size:1.15em; line-height:2;">
                <li>「質感霧面透明提袋」一份</li>
                <li>「精美祝福卡」一份</li>
            </ul>
        </div>

        <div