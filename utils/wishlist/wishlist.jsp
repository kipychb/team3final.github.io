<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../config.jsp" %>
<%
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
%>
<p class="empty-msg">請先<a href="../member/login/index.jsp">登入</a>以查看願望清單</p>
<%
    } else {
        int memberID = (int) midObj;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean hasItem = false;
        try {
            ps = con.prepareStatement(
                "SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.Series, p.Image " +
                "FROM `wishlist` w JOIN `product` p ON w.ProductID = p.ProductID " +
                "WHERE w.MemberID = ? ORDER BY p.ProductID ASC"
            );
            ps.setInt(1, memberID);
            rs = ps.executeQuery();
            while (rs.next()) {
                hasItem = true;
                int pid      = rs.getInt("ProductID");
                String pname = rs.getString("ProductName");
                double price = rs.getDouble("Price");
                String series = rs.getString("Series");
                String image  = rs.getString("Image");

                String imgPath;
                if (image != null && !image.trim().isEmpty()) {
                    String img = image.trim();
                    imgPath = img.matches("\\d+-1\\.jpg")
                        ? "../image/flower/" + img.replace("-1.jpg", "-2.jpg")
                        : "../image/flower/" + img;
                } else {
                    imgPath = "../image/default.jpg";
                }
                String prodUrl  = "../product/index.jsp?id=" + pid;
                String priceStr = String.format("%,.0f", price);
%>
<div class="item">
    <div class="img-box border-box">
        <a href="<%= prodUrl %>">
            <img src="<%= imgPath %>" alt="<%= pname %>" onerror="this.src='../image/default.jpg'">
        </a>
        <form method="post" action="../utils/wishlist/toggle_wishlist.jsp" style="display:inline; margin:0">
            <input type="hidden" name="product_id" value="<%= pid %>">
            <input type="hidden" name="redirect" value="member/index.jsp?tab=wishlist">
            <button type="submit" class="remove-btn"><i class="fa-solid fa-xmark"></i></button>
        </form>
    </div>
    <div class="info">
        <div class="main-text">
            <span class="tag"><%= pname %><br>[<%= series %> 系列]</span>
            <span class="price">NT$ <%= priceStr %></span>
        </div>
        <div class="item-actions" style="display:flex; gap:8px; align-items:center;">
            <div class="share-wrapper" style="position:relative;">
                <button class="share-btn-inner" onclick="copyProductLink('<%= prodUrl %>', this)">
                    <i class="fa-solid fa-share-nodes"></i>
                </button>
                <span class="tooltip">複製成功！</span>
            </div>
            <button class="add-btn" onclick="handleWishlistAddToCart('<%= pname %>', <%= price %>)">
                <i class="fa-solid fa-plus"></i>
            </button>
        </div>
    </div>
</div>
<%
            }
        } catch (Exception e) {
            out.println("<p class='empty-msg'>載入失敗：" + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        }
        if (!hasItem) {
%>
<p class="empty-msg">您的願望清單空空如也...</p>
<%
        }
    }
%>
