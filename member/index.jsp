<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../utils/config.jsp" %>
<html lang="zh-TW">

    <%
        if (session.getAttribute("mid") == null) {
            response.sendRedirect("login/index.jsp");
            return;
        }

        int MemberID = (int) session.getAttribute("mid");
        
        String sql = "SELECT * FROM `member` WHERE MemberID = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, MemberID);
        
        ResultSet rs=pstmt.executeQuery();
        rs.next();
    %>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>會員中心 | 花予祝願所</title>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap"
        rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="../utils/cart/style.css">
        <link rel="stylesheet" href="../utils/side-menu/style.css">
    </head>

    <body>

        <header class="navbar">

            <div class="nav-logo">會員中心</div>
            <div class="nav-right">
                <i class="fa-solid fa-basket-shopping nav-icon" onclick="toggleCart()"></i>
                <i class="fa-solid fa-bars nav-icon" id="menu-trigger"></i>
            </div>
        </header>

        <main class="member-wrapper">
            <nav class="flower-nav">
                <div class="flower-item active" onclick="switchSection('user-info', this)">
                    <div class="flower-icon-box">
                        <img src="image/1.png" alt="使用者資訊" class="flower-img">
                    </div>
                    <span class="flower-label">會員資訊</span>
                </div>
                <div class="flower-item" onclick="switchSection('orders', this)">
                    <div class="flower-icon-box">
                        <img src="image/2.png" alt="訂單紀錄" class="flower-img">
                    </div>
                    <span class="flower-label">訂單與紀錄</span>
                </div>
                <div class="flower-item" onclick="switchSection('wishlist', this)">
                    <div class="flower-icon-box">
                        <img src="image/3.png" alt="願望清單" class="flower-img">
                    </div>
                    <span class="flower-label">願望清單</span>
                </div>
                <div class="flower-item" onclick="switchSection('flower-search', this)">
                    <div class="flower-icon-box">
                        <img src="image/4.png" alt="花語查詢" class="flower-img">
                    </div>
                    <span class="flower-label">花語查詢</span>
                </div>
            </nav>

            <div class="content-display">

                <div id="user-info" class="section-block active">
                    <h3 class="block-title">會員資訊</h3>
                    <div class="info-list">
                        <div class="info-row">
                            <span class="info-label">會員等級</span>
                            <span class="status-tag highlight">
                                <%=rs.getString("Rank")%>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">真實姓名</span>
                            <div class="value-group">
                                <span class="info-value" id="display-name">
                                    <%=rs.getString("MemberName")%>
                                </span>
                                <input type="text" id="edit-name" class="edit-input" style="display:none;">
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">出生日期</span>
                            <div class="value-group">
                                <span class="info-value" id="display-birth">
                                    <%=rs.getDate("BirthDay")%>
                                </span>
                                <input type="date" id="edit-birth" class="edit-input" style="display:none;">
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">聯絡信箱</span>
                            <div class="value-group">
                                <span class="info-value" id="display-email">
                                    <%=rs.getString("Email")%>
                                </span>
                                <input type="email" id="edit-email" class="edit-input" style="display:none;">
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">手機號碼</span>
                            <div class="value-group">
                                <span class="info-value" id="display-phone">
                                    <%=rs.getString("Phone")%>
                                </span>
                                <input type="tel" id="edit-phone" class="edit-input" style="display:none;">
                            </div>
                        </div>

                        <div class="info-row coupon-row">
                            <span class="info-label">我的優惠券</span>

                            <div class="coupon-area">
                                <div class="coupon-header" onclick="toggleCouponBox()">
                                    <span>點擊查看 / 收合優惠券</span>
                                    <i class="fa-solid fa-chevron-down"></i>
                                </div>

                                <div id="coupon-box" class="coupon-box">
                                    <% String couponSql="SELECT * FROM member_coupons WHERE member_id = ?" ;
                                        PreparedStatement couponPstmt=con.prepareStatement(couponSql);
                                        couponPstmt.setInt(1, MemberID); ResultSet
                                        couponRs=couponPstmt.executeQuery(); boolean hasCoupon=false; while
                                        (couponRs.next()) { hasCoupon=true; String
                                    couponStatus=couponRs.getString("status"); %>

                                    <div class="coupon-card-member">
                                        <div class="coupon-card-left">
                                            <i class="fa-solid fa-gift coupon-icon"></i>
                                            <div>
                                                <p class="coupon-title">
                                                    NT$ <%= couponRs.getInt("coupon_amount") %> 折價券
                                                </p>
                                                <p class="coupon-desc">結帳時可折抵使用</p>
                                            </div>
                                        </div>

                                        <span class="coupon-status <%= couponStatus.equals(" 未使用")
                                        ? "status-available" : "status-used" %>">
                                        <%= couponStatus %>
                                    </span>
                                </div>

                                <% } if (!hasCoupon) { %>
                                <div class="coupon-empty">目前沒有可用優惠券</div>
                                <% } couponRs.close(); couponPstmt.close(); %>
                            </div>
                        </div>
                    </div>




                </div>

                <div class="action-group">
                    <% if (rs.getString("Rank") != null && rs.getString("Rank").trim().equals("管理員")) { %>
                    <button class="action-btn" style="background-color: #705844; color: #fff;" onclick="location.href='../admin/index.jsp'">進入管理員頁面</button>
                    <% } %>

                    <button class="action-btn" id="edit-btn" onclick="toggleEditMode()">修改個人資料</button>
                    <button class="action-btn logout-btn" onclick="logout()">登出帳號</button>
                </div>
            </div>
            <div id="orders" class="section-block">
                <h3 class="block-title">訂單與紀錄</h3>
                <div class="list-container">
                </div>
            </div>
            <div id="wishlist" class="section-block">
                <h3 class="block-title">願望清單</h3>
                <div class="list-container" id="simple-wishlist-container">
                    <jsp:include page="../utils/wishlist/wishlist.jsp" />
                </div>
            </div>

            <div id="flower-search" class="section-block">
                <h3 class="block-title">尋找花語</h3>
                <div class="search-area">
                    <div class="search-bar-member">
                        <input type="text" placeholder="搜尋花卉名稱(e.g. 摯愛)...">
                    </div>
                    <div class="today-tip">
                        <h4>今日祝願花：鬱金香</h4>
                        <p>花語：永恆的愛與祝願。提醒我們，愛是生活中最溫柔的支撐</p>
                    </div>
                </div>
            </div>

        </div>
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

    <!-- Java Script 存放區 -->
    <script src="../utils/cart/main.jsp"></script>
    <script src="../utils/side-menu/main.jsp"></script>
    <script src="main.jsp"></script>
    <script src="search.jsp"></script>
    <script src="login/login.jsp"></script>

    <script>
        function toggleCouponBox() {
            var box = document.getElementById("coupon-box");
            
            if (box.style.display === "none") {
                box.style.display = "block";
            } else {
                box.style.display = "none";
            }
        }
    </script>

</body>

</html>