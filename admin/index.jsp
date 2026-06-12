<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        out.println("<script>alert('請以管理員身分登入！'); window.location.href='../index.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>後台管理 — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">花予祝願所 後台管理</h1>
        <span class="admin-subtitle">商品管理</span>
    </div>

    <div class="admin-actions">
        <a href="product_add.jsp" class="admin-btn btn-primary">＋ 上架新產品</a>
        <a href="order.jsp"       class="admin-btn btn-secondary">≡ 瀏覽所有訂單</a>
        <a href="../index.jsp"    class="admin-btn btn-neutral">⌂ 返回前台首頁</a>
    </div>

    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>商品圖片</th>
                    <th>產品名稱</th>
                    <th>分類</th>
                    <th>價格</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    if (con == null) {
            %>
                <tr class="table-error"><td colspan="6">❌ 資料庫連線失敗，請檢查 config.jsp</td></tr>
            <%
                    } else {
                        String sql = "SELECT * FROM product ORDER BY ProductID ASC";
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        boolean hasRow = false;
                        while (rs.next()) {
                            hasRow = true;
                            int    pId      = rs.getInt("ProductID");
                            String category = rs.getString("Category");
                            String imgUrl   = rs.getString("Image");
                            String finalImgPath;

                            if (imgUrl != null && !imgUrl.trim().isEmpty() && !imgUrl.trim().equalsIgnoreCase("null")) {
                                String img = imgUrl.trim();
                                finalImgPath = img.matches("\\d+-1\\.jpg")
                                    ? "../image/flower/" + img.replace("-1.jpg", "-2.jpg")
                                    : "../image/flower/" + img;
                            } else {
                                finalImgPath = "../image/default.jpg";
                            }
            %>
                <tr>
                    <td class="col-id"><%= pId %></td>
                    <td>
                        <img class="thumb" src="<%= finalImgPath %>"
                             onerror="this.onerror=null; this.src='../image/default.jpg';"
                             alt="<%= rs.getString("ProductName") %>">
                    </td>
                    <td style="font-weight:600;"><%= rs.getString("ProductName") %></td>
                    <td><%= category %></td>
                    <td class="col-price">NT$ <%= String.format("%,d", rs.getInt("Price")) %></td>
                    <td>
                        <a class="action-edit"   href="product_edit.jsp?id=<%= pId %>">✏ 修改</a>
                        <a class="action-delete" href="action/do_delete.jsp?id=<%= pId %>"
                           onclick="return confirm('確定要刪除「<%= rs.getString("ProductName") %>」？')">🗑 刪除</a>
                    </td>
                </tr>
            <%
                        }
                        if (!hasRow) {
            %>
                <tr><td colspan="6" class="admin-empty">目前沒有任何商品</td></tr>
            <%
                        }
                        rs.close();
                        stmt.close();
                    }
                } catch (Exception e) {
            %>
                <tr class="table-error"><td colspan="6">錯誤：<%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
