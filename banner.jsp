<%@page contentType="text/html;charset=utf-8" language="java" import="java.util.*" %>
<%
    // 1. 伺服器端配置：未來您可以很輕易地將這裡改為自資料庫讀取
    int bannerInterval = 5000; // 輪播秒數（毫秒）

    // 定義輪播廣告資料結構
    List<Map<String, String>> banners = new ArrayList<>();
    
    Map<String, String> b1 = new HashMap<>();
    b1.put("link", "product/index.jsp?id=1");
    b1.put("img", "image/banner/1.jpg");
    b1.put("alt", "廣告 1");
    banners.add(b1);
    
    Map<String, String> b2 = new HashMap<>();
    b2.put("link", "member/benefits.jsp");
    b2.put("img", "image/banner/2.jpg");
    b2.put("alt", "廣告 2");
    banners.add(b2);
    
    Map<String, String> b3 = new HashMap<>();
    b3.put("link", "product/index.jsp?id=3");
    b3.put("img", "image/banner/3.jpg");
    b3.put("alt", "廣告 3");
    banners.add(b3);

    int totalBanners = banners.size();
%>

<div class="banner-wrapper-jsp">
    <!-- 輪播圖圖片區 -->
    <div class="banner-container-jsp" id="bannerSliderJSP">
        <%
            for (Map<String, String> banner : banners) {
        %>
            <a href="<%= banner.get("link") %>" style="">
                <img src="<%= banner.get("img") %>" alt="<%= banner.get("alt") %>">
            </a>
        <%
            }
        %>
    </div>

    <!-- 輪播圖導覽點點 -->
    <div class="banner-dots-jsp" id="bannerDotsJSP">
        <%
            for (int i = 0; i < totalBanners; i++) {
                String activeClass = (i == 0) ? "active" : "";
        %>
            <span class="dot <%= activeClass %>" data-index="<%= i %>"></span>
        <%
            }
        %>
    </div>
</div>

<!-- 輪播圖控制腳本 -->
<script>
(function() {
    // 獨立作用域，避免與其他腳本變數衝突
    document.addEventListener('DOMContentLoaded', () => {
        const container = document.getElementById('bannerSliderJSP');
        const dots = document.querySelectorAll('#bannerDotsJSP .dot');
        const total = <%= totalBanners %>;
        let current = 0;
        let timer = null;

        if (!container || total === 0) return;

        // 切換輪播圖核心函數
        function show(index) {
            // 由於子元素皆為 100% 寬，這裡可以直接用整數百份比進行位移，寫法更乾淨且完美相容各大瀏覽器
            container.style.transform = 'translateX(-' + (index * 100) + '%)';
            dots.forEach(dot => dot.classList.remove('active'));
            if (dots[index]) dots[index].classList.add('active');
            current = index;
        }

        function next() {
            let nextIndex = (current + 1) % total;
            show(nextIndex);
        }

        function startTimer() {
            timer = setInterval(next, <%= bannerInterval %>);
        }

        function resetTimer() {
            clearInterval(timer);
            startTimer();
        }

        // 點點點擊事件監聽
        dots.forEach(dot => {
            dot.addEventListener('click', (e) => {
                const idx = parseInt(e.target.getAttribute('data-index'));
                show(idx);
                resetTimer(); // 點擊後重新計時
            });
        });

        // 啟動自動輪播
        startTimer();
    });
})();
</script>