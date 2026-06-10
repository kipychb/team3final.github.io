<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String idStr = request.getParameter("id");  // 注意這裡改成接收 "id"
    int productId = 0;
    try {
        productId = Integer.parseInt(idStr);
    } catch(Exception e) {
        out.println("<script>alert('無效的產品ID！'); window.location.href='index.jsp';</script>");
        return;
    }

    // 從資料庫載入產品資料
    String productName = "";
    String category = "fresh";
    int price = 0;
    String idea = "";
    String image = "";

    try {
        if (con != null) {
            String sql = "SELECT * FROM product WHERE ProductID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                productName = rs.getString("ProductName");
                category = rs.getString("Category");
                price = rs.getInt("Price");
                idea = rs.getString("Idea") != null ? rs.getString("Idea") : "";
                image = rs.getString("Image") != null ? rs.getString("Image") : ""; // 💡 2. 從資料庫把 Image 讀取出來
            }
            rs.close();
            pstmt.close();
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改產品資訊</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body style="padding:30px; background:#eeebe2;">
    <h2>✏️ 修改產品資訊 (ID: <%= productId %>)</h2>
    
    <form action="action/do_edit.jsp" method="post">
        <input type="hidden" name="ProductID" value="<%= productId %>">
        
        產品名稱: <input type="text" name="ProductName" value="<%= productName %>" required><br><br>
        分類: <input type="text" name="Category" value="<%= category %>" required><br><br>
        價格: <input type="number" name="Price" value="<%= price %>" required><br><br>
        描述: <textarea name="Description" rows="6" cols="60"><%= idea %></textarea><br><br>
        產品圖片 (網址或本機檔名): <input type="text" name="Image" value="<%= image %>" style="width: 60%;" placeholder="例如：image_36d4ff.jpg 或 https://..."><br><br>
        
        <button type="submit">✅ 確認修改</button>
        <a href="index.jsp">← 返回後台</a>
    </form>
</body>
</html>