<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    int productId = 0;
    try {
        productId = Integer.parseInt(idStr);
    } catch (Exception e) {
        out.println("<script>alert('無效的產品ID！'); window.location.href='index.jsp';</script>");
        return;
    }

    String productName = "", category = "fresh", idea = "", image = "";
    int price = 0;

    try {
        if (con != null) {
            PreparedStatement pstmt = con.prepareStatement("SELECT * FROM product WHERE ProductID = ?");
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                productName = rs.getString("ProductName");
                category    = rs.getString("Category");
                price       = rs.getInt("Price");
                idea        = rs.getString("Idea")  != null ? rs.getString("Idea")  : "";
                image       = rs.getString("Image") != null ? rs.getString("Image") : "";
            }
            rs.close(); pstmt.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>修改產品 #<%= productId %> — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">修改產品資訊</h1>
        <span class="admin-subtitle">ID：<%= productId %></span>
    </div>

    <a class="admin-back-link" href="index.jsp">← 返回商品列表</a>

    <div class="admin-form-card">
        <form class="admin-form" action="action/do_edit.jsp" method="post">
            <input type="hidden" name="ProductID" value="<%= productId %>">

            <div class="form-row">
                <label for="ProductName">產品名稱</label>
                <input type="text" id="ProductName" name="ProductName" value="<%= productName %>" required>
            </div>

            <div class="form-row">
                <label for="Category">分類</label>
                <input type="text" id="Category" name="Category" value="<%= category %>" required>
                <span class="form-hint">例如：fresh、dried、bouquet</span>
            </div>

            <div class="form-row">
                <label for="Price">價格（NT$）</label>
                <input type="number" id="Price" name="Price" value="<%= price %>" required>
            </div>

            <div class="form-row">
                <label for="Description">商品描述</label>
                <textarea id="Description" name="Description" rows="6"><%= idea %></textarea>
            </div>

            <div class="form-row">
                <label for="Image">產品圖片（檔名或網址）</label>
                <input type="text" id="Image" name="Image" value="<%= image %>"
                       placeholder="例如：1-1.jpg 或 https://...">
                <span class="form-hint">留空則維持原圖片不變</span>
            </div>

            <div class="form-footer">
                <button type="submit" class="admin-btn btn-primary">✔ 確認修改</button>
                <a href="index.jsp" class="admin-btn btn-ghost">取消</a>
            </div>
        </form>
    </div>

</div>
</body>
</html>
