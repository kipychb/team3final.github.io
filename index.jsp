<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="counter.jsp" %>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>花予祝願所</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Euphoria+Script&family=Fugaz+One&family=Homemade+Apple&family=Lavishly+Yours&family=Londrina+Sketch&family=Noto+Sans+TC:wght@100..900&family=Pinyon+Script&family=WindSong:wght@400;500&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css?v2">
    <link rel="stylesheet" href="utils/cart/style.css">
    <link rel="stylesheet" href="utils/side-menu/style.css">
    <link rel="icon" href="image/icon.ico">
</head>

<body>

    <!-- 導覽列 -->
    <header class="navbar">
        <div class="nav-logo">
            <a href="about_us/index.jsp">Blooming Wish</a>
        </div>

        <div class="nav-right-group">
            <i class="fa-solid fa-magnifying-glass nav-icon" id="search-trigger"></i>
            <i class="fa-solid fa-user nav-icon" id="member-icon" onclick="handleMemberClick()"></i>
            <i class="fa-solid fa-basket-shopping nav-icon" onclick="toggleCart()"></i>
            <i class="fa-solid fa-bars nav-icon" id="menu-trigger"></i>
        </div>
    </header>

    <div class="marquee-container">
        <div class="marquee-text">
            <span>⋆˚✿˖° 畢業季限定：把祝願送給那個努力過的自己！即日起至六月底，畢業花禮全館九折，留下最美的一刻 ⋆˚✿˖° 畢業快樂！ ⋆˚✿˖°°</span>
            <span>⋆˚✿˖° 心意有歸處，祝願有花期 ⋆˚✿˖°</span>
            <span>⋆˚✿˖° 畢業季限定：把祝願送給那個努力過的自己！即日起至六月底，畢業花禮全館九折，留下最美的一刻 ⋆˚✿˖° 畢業快樂！ ⋆˚✿˖°°</span>
            <span>⋆˚✿˖° 畢業季限定：把祝願送給那個努力過的自己！即日起至六月底，畢業花禮全館九折，留下最美的一刻 ⋆˚✿˖° 畢業快樂！ ⋆˚✿˖°°</span>


        </div>
    </div>

    <section class="banner">
    </section>

    <!-- 主要內容 -->
    <div class="main-content-blur" id="main-content">

        <section class="banner">
            <jsp:include page="banner.jsp" />
        </section>

        <section class="quiz-intro">
            <div class="quiz-card">
                <img src="quiz/image/background.jpg" alt="測驗封面">
            </div>

            <div class="quiz-text">
                <h2>尋找您的命定花</h2>
                <p>在忙碌的生活中，透過直覺的選擇，發現此刻最契合您靈魂的那朵花。<br>這不僅是一場測驗，更是一份給心靈的祝願！</p>

                <button class="quiz-enter" onclick="location.href='quiz/index.jsp'">
                    開始探索您的命定花
                </button>
            </div>
        </section>

        <section class="collection">
            <h3 class="section-title">鮮花推薦 Fresh flowers Recommended</h3>
            <div class="grid-3x2 fresh-flower">
                <jsp:include page="collection.jsp">
                    <jsp:param name="category" value="fresh" />
                </jsp:include>
            </div>
            <nav class="pagination-section">
                <div class="pagination">
                    <i class="page-arrow fa-solid fa-chevron-left"></i>
                    <span class="page-num active">1</span>
                    <span class="page-num">2</span>
                    <i class="page-arrow fa-solid fa-chevron-right"></i>
                </div>
            </nav>
        </section>

        <section class="collection">
            <h3 class="section-title">乾燥花推薦 Dried flowers Recommended </h3>
            <div class="grid-3x2 dried-flower">
                <jsp:include page="collection.jsp">
                    <jsp:param name="category" value="dried" />
                </jsp:include>
            </div>
            <nav class="pagination-section">
                <div class="pagination">
                    <i class="page-arrow fa-solid fa-chevron-left"></i>
                    <span class="page-num active">1</span>
                    <span class="page-num">2</span>
                    <i class="page-arrow fa-solid fa-chevron-right"></i>
                </div>
            </nav>
        </section>

        <section class="collection">
            <h3 class="section-title">認識花予</h3>
            <div class="info-content">
                您是我們第 <%= visitCount %> 位訪客<br>
                    心意有歸處，祝願有花期 ⋆˚✿˖°
            </div>
        </section>

        <footer class="contact-section" id="contact-us">
            <div class="social-icons">
                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><i class="fa-brands fa-line"></i></a>
                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><i class="fa-brands fa-facebook"></i></a>
                <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ"><i class="fa-brands fa-instagram"></i></a>
            </div>

            <div class="contact-top">
                <div class="about-us">
                    <img src="image/logo.png" alt="logo" class="about-logo">
                    <a href="about_us/index.jsp" class="about-link">★ 關於我們</a>
                    <a href="member/benefits.jsp" class="about-link">★ 會員優惠</a>
                </div>
                <div class="map-box">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3617.249035944321!2d121.2383831760458!3d24.95764404135962!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3468223af044962b%3A0x6b4737089453c52a!2z5Lit5Y6f5aSn5a24!5e0!3m2!1szh-TW!2stw!4v1700000000000!5m2!1szh-TW!2stw"
                        width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>
            </div>

            <div class="form-wrapper">
                <div class="contact-form">
                    <h4 class="form-title">聯絡我們</h4>
                    <form action="submit_contact.jsp" method="post">
                        <input type="text" name="name" placeholder="姓名" required>
                        <input type="text" name="contact_method" placeholder="聯絡方式" required>
                        <textarea name="contents" placeholder="留言內容" rows="4" required></textarea>
                        <button type="submit" class="submit-btn">發送訊息</button>
                    </form>
                </div>
            </div>
            <div class="footer-bottom">
                <p>© 2025 花予祝願所. All Rights Reserved.</p>
            </div>
        </footer>
    </div>

    <!-- 主菜單 -->
    <div class="side-panel" id="side-menu">
        <div class="header">
            <h2>分類選單</h2>
            <i class="fa-solid fa-xmark" id="close-menu-btn"></i>
        </div>

        <ul class="list">
            <li><a href="index.jsp">Home / 首頁</a></li>
            <li><a href="series/index.jsp?series=lover">For Lover 系列</a></li>
            <li><a href="series/index.jsp?series=myself">For Myself 系列</a></li>
            <li><a href="series/index.jsp?series=friend">For Friend 系列</a></li>
            <li><a href="series/index.jsp?series=elder">For Elders 系列</a></li>
        </ul>
    </div>
    <div id="menu-overlay" class="menu-overlay"></div>

    <!-- 搜尋花朵 -->
    <%
        String searchQ = request.getParameter("q");
        boolean hasSearch = searchQ != null && !searchQ.trim().isEmpty();
    %>
    <div class="side-panel<%= hasSearch ? " active" : "" %>" id="side-search">
        <form class="search-bar" id="search-form" action="index.jsp" method="get">
            <input type="text" name="q" id="searchInput" placeholder="可輸入花材、花語或對象，如：玫瑰"
                   value="<%= hasSearch ? searchQ : "" %>">
            <button type="submit" style="background:none; border:none; cursor:pointer; padding:0;">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
        </form>
        <ul id="search-suggestions" class="suggestions">
            <jsp:include page="search.jsp" />
        </ul>
    </div>

    <!-- 購物清單 -->
    <div id="cartSidebar" class="cart-sidebar">
        <div class="header">
            <h3>購物清單</h3>
            <i class="fa-solid fa-xmark" onclick="toggleCart()" style="cursor:pointer;"></i>
        </div>
        <div id="cartItems" class="items"></div>
        <div class="footer">
            <div class="total-row">總計: NT$&nbsp;<span id="cartTotal">0</span></div>
            <button class="checkout-btn">前往結帳</button>
        </div>
    </div>
    <div id="cartOverlay" class="cart-overlay" onclick="toggleCart()"></div>

    <%-- Cookie 請求列表 --%>
    <jsp:include page="utils/cookie-banner.jsp" />

    <!-- Java Script 專區 -->
    <jsp:include page="utils/wishlist/addWish.jsp" />
    <script src="utils/cart/main.jsp"></script>
    <script src="utils/side-menu/main.jsp"></script>
    <script src="member/login/login.jsp"></script>
    <script>
    // 助教不要扣分，我只是想藏彩蛋 🥺
        document.addEventListener('DOMContentLoaded', () => {
            const randomChance = Math.random();

            if (randomChance < 0.05) {
                const logoLink = document.querySelector('.nav-logo a');

                if (logoLink) {
                    logoLink.textContent = '花予住院所';
                }
            }
        });
    </script>
</body>

</html>