<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    // 恢復權限檢查
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        out.println("<script>alert('請以管理員身分登入！'); window.location.href='../index.jsp';</script>");
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
    
    <div style="margin-bottom: 20px;">
        <a href="product_add.jsp" style="padding:10px 20px; background:#705844; color:white; text-decoration:none; border-radius:5px; margin-right:10px; display:inline-block;">➕ 上架新產品</a>
        <a href="order.jsp" style="padding:10px 20px; background:#A3A69C; color:white; text-decoration:none; border-radius:5px; display:inline-block;">📋 瀏覽所有訂單</a>
        <a href="../index.jsp" style="padding:10px 20px; background:#666; color:white; text-decoration:none; border-radius:5px; display:inline-block;">🏠 返回前台首頁</a>
    </div>
    
    <table border="1" width="100%" style="border-collapse: collapse; text-align: left; background: white;">
        <tr style="background-color: #705844; color: white;">
            <th style="padding: 10px;">ID</th>
            <th style="padding: 10px;">商品圖片</th>
            <th style="padding: 10px;">產品名稱</th>
            <th style="padding: 10px;">分類</th>
            <th style="padding: 10px;">價格</th>
            <th style="padding: 10px;">操作</th>
        </tr>
        <%
            try {
                // 配合你原本的專案設定，使用 request 取得資料庫連線
                Connection dbCon = (Connection) request.getAttribute("con");
                
                if (dbCon == null) {
                    out.println("<tr><td colspan='6' style='color:red; padding: 10px;'>❌ 資料庫連線失敗，請檢查 config.jsp</td></tr>");
                } else {
                    String sql = "SELECT * FROM product ORDER BY ProductID DESC";
                    Statement stmt = dbCon.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                   
                    while(rs.next()) {
                        String imgUrl = rs.getString("Image");
                        
                        // 過濾各種 null 與 "null" 字串的防錯邏輯
                        boolean isUrl = false;
                        String finalImgPath = "";

                        if (imgUrl != null && !imgUrl.trim().isEmpty() && !imgUrl.trim().equalsIgnoreCase("null")) {
                            imgUrl = imgUrl.trim();
                            if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
                                isUrl = true;
                                finalImgPath = imgUrl;
                            } else {
                                finalImgPath = "../images/" + imgUrl;
                            }
                        } else {
                            finalImgPath = "../images/default.jpg"; 
                        }
        %>
        <tr>
            <td style="padding: 10px;"><%= rs.getInt("ProductID") %></td>
            <td style="padding: 10px;">
                <img src="<%= finalImgPath %>" width="80" height="80" style="object-fit: cover; border-radius: 4px;" onerror="this.src='../images/default.jpg';">
            </td>
            <td style="padding: 10px; font-weight: bold;"><%= rs.getString("ProductName") %></td>
            <td style="padding: 10px;"><%= rs.getString("Category") %></td>
            <td style="padding: 10px; color: #705844;">$<%= rs.getInt("Price") %></td>
            <td style="padding: 10px;">
                <a href="product_edit.jsp?id=<%= rs.getInt("ProductID") %>" style="color: #705844; text-decoration: none; margin-right: 10px;">✏️ 修改</a>
                <a href="action/do_delete.jsp?id=<%= rs.getInt("ProductID") %>" onclick="return confirm('確定要刪除此產品？')" style="color: red; text-decoration: none;">🗑️ 刪除</a>
            </td>
        </tr>
        <% 
                    } 
                    
                    rs.close(); 
                    stmt.close();
                } 
                
            } catch(Exception e) { 
                out.println("<tr><td colspan='6' style='color:red; padding: 10px;'>錯誤: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>