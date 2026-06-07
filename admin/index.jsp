<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    // 恢復權限檢查
    if (!"管理員".equals(session.getAttribute("Rank"))) {
        out.println("<script>alert('請以管理員身分登入！'); window.location.href='/index.jsp';</script>");
        return;
    }
%>  
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>後台管理 - 花店</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body style="padding:30px; background:#eeebe2; font-family:Arial;">
    <h1>🌸 花店後台管理系統</h1>
    <p>歡迎，管理員</p>
    
    <a href="product_add.jsp" style="padding:5px 20px; background:#705844; color:white; text-decoration:none; border-radius:5px; margin-right:10px;">➕ 上架新產品</a>
    <a href="order.jsp" style="padding:5px 20px; background:#A3A69C; color:white; text-decoration:none; border-radius:5px;">📋 瀏覽所有訂單</a>
    <a href="/index.jsp" style="padding:5px 20px; background:#666; color:white; text-decoration:none; border-radius:5px;">返回首頁</a>

    <h3>目前產品列表</h3>
    <table border="1" width="100%" style="border-collapse:collapse; background:white;">
        <tr style="background:#A3A69C; color:white;">
            <th>ID</th>
            <th>產品名稱</th>
            <th>分類</th>
            <th>價格</th>
            <th>操作</th>
        </tr>
        <%
            try {
                // 重要：不要重新宣告 con，使用 config.jsp 已經提供的 con
                Connection dbCon = (Connection) request.getAttribute("con");
                
                if (dbCon == null) {
                    out.println("<tr><td colspan='5' style='color:red;'>❌ 資料庫連線失敗，請檢查 config.jsp</td></tr>");
                } else {
                    String sql = "SELECT * FROM product ORDER BY ProductID DESC";
                    Statement stmt = dbCon.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("ProductID") %></td>
            <td><%= rs.getString("ProductName") %></td>
            <td><%= rs.getString("Category") %></td>
            <td>$<%= rs.getInt("Price") %></td>
            <td>
                <a href="product_edit.jsp?id=<%= rs.getInt("ProductID") %>">修改</a> |
                <a href="action/do_delete.jsp?id=<%= rs.getInt("ProductID") %>" 
                   onclick="return confirm('確定要刪除此產品？')">刪除</a>
            </td>
        </tr>
        <% 
                    }
                    rs.close(); 
                    stmt.close();
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>錯誤: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>