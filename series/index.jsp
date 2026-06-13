<%@page contentType="text/html;charset=utf-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品分頁 | 花予祝願所</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Euphoria+Script&family=Fugaz+One&family=Homemade+Apple&family=Lavishly+Yours&family=Londrina+Sketch&family=Noto+Sans+TC:wght@100..900&family=Pinyon+Script&family=WindSong:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css?v=31">
    <link rel="stylesheet" href="../utils/cart/style.css">
    <link rel="stylesheet" href="../utils/side-menu/style.css">
</head>

<body>

    <!-- 導覽列 -->
    <header class="navbar">
        <div class="nav-left nav-icon">
            <a href="javascript:history.back()" class="home-link">
                <i class="fa-solid fa-chevron-left nav-icon"></i>
            </a>
        </div>
        <div class="logo"></div>
        <div class="nav-right">
            <i class="fa-solid fa-magnifying-glass nav-icon" id="search-trigger"></i>
            <a href="../member/index.jsp?tab=wishlist" class="link nav-icon">
                <i class="fa-solid fa-heart icon"></i>
            </a>
            <i class="fa-solid fa-basket-shopping nav-icon" onclick="toggleCart()"></i>
            <i class="fa-solid fa-bars nav-icon" id="menu-trigger"></i>
        </div>
    </header>

    <main class="category-wrapper">
        <h3 class="section-title">［For Lover系列］</h3>
        <div class="product-grid"></div>
    </main>

    <!-- 主菜單 -->
    <div class="side-panel" id="side-menu">
        <div class="header">
            <h2>分類選單</h2>
            <i class="fa-solid fa-xmark" id="close-menu-btn"></i>
        </div>
        <ul class="list">
            <li><a href="../index.jsp">Home / 首頁</a></li>
            <li><a href="../series/index.jsp?series=lover">For Lover 系列</a></li>
            <li><a href="../series/index.jsp?series=myself">For Myself 系列</a></li>
            <li><a href="../series/index.jsp?series=friend">For Friend 系列</a></li>
            <li><a href="../series/index.jsp?series=elder">For Elders 系列</a></li>
        </ul>
    </div>
    <div id="menu-overlay" class="menu-overlay"></div>

    <!-- 搜尋花朵 -->
    <%
        String searchQ = request.getParameter("q");
        boolean hasSearch = searchQ != null && !searchQ.trim().isEmpty();
    %>
    <div class="side-panel<%= hasSearch ? " active" : "" %>" id="side-search">
        <form class="search-bar" id="search-form" action="../index.jsp" method="get">
            <input type="text" name="q" id="searchInput" placeholder="可輸入花材、花語或對象，如：玫瑰"
                   value="<%= hasSearch ? searchQ : "" %>">
            <button type="submit" style="background:none; border:none; cursor:pointer; padding:0;">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
        </form>
        <ul id="search-suggestions" class="suggestions">
            <jsp:include page="../search.jsp" />
        </ul>
    </div>

    <!-- 購物車 -->
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

    <jsp:include page="../utils/wishlist/addWish.jsp" />
    <script src="../utils/cart/main.jsp"></script>
    <script src="../utils/side-menu/main.jsp"></script>
    <script src="loader.jsp"></script>
</body>

</html>
