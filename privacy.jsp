<%@ page contentType="text/html;charset=utf-8" language="java" import="java.util.Calendar" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>隱私權政策 | 花予祝願所</title>
    <link rel="stylesheet" href="style.css">

</head>
<body>

    <div class="privacy-container">
        <h1>🌸 隱私權政策</h1>
        
        <p>本網站（花予祝願所）非常重視您的個人資料保護，嚴格遵守《個人資料保護法》（個資法）及其他相關法規。</p>

        <h2>一、我們收集哪些資料？</h2>
        <p>我們僅收集完成交易與提供服務所必要之個人資料，包括：</p>
        <ul>
            <li>姓名、聯絡電話、電子郵件</li>
            <li>收件地址</li>
            <li>訂單相關資訊</li>
            <li>生日（用於會員優惠）</li>
        </ul>

        <h2>二、Cookie 使用說明</h2>
        <p>本網站使用 Cookie 來提升您的使用體驗，例如：</p>
        <ul>
            <li>記住您的登入狀態</li>
            <li>購物車功能（包含本地儲存商品暫存）</li>
            <li>網站流量分析（匿名）</li>
        </ul>
        <p>您可以隨時在瀏覽器設定中管理或拒絕 Cookie，但可能會影響部分功能（如購物車）的正常運作。</p>

        <h2>三、資料使用目的</h2>
        <p>您的個人資料僅用於以下目的：</p>
        <ul>
            <li>訂單處理、金流串接與商品配送</li>
            <li>會員服務、點數回饋與優惠通知</li>
            <li>客服、退換貨處理與售後服務</li>
            <li>網站系統功能優化</li>
        </ul>

        <h2>四、資料保護與不外洩</h2>
        <p>我們承諾不會將您的個人資料出售、出租或提供給任何第三方商業機構。資料僅在法律要求或經您同意的情況下才會揭露。</p>

        <h2>五、您的權利</h2>
        <p>您有權隨時要求查詢、更正、刪除您的個人資料，請透過聯絡我們頁面或客服管道提出申請。</p>

        <%
            // 動態獲取當前年份，讓頁面更新時間自動保持在最新狀態
            int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        %>
        <p class="update-note">最後更新日期：<%= currentYear %>年6月</p>

        <div class="back-btn-wrap">
            <a href="index.jsp" class="back-btn">← 返回首頁</a>
        </div>
    </div>

</body>
</html>