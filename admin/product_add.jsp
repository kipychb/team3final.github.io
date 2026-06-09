<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>上架新產品</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body style="padding:30px; background:#eeebe2;">
    <h2>➕ 上架新產品</h2>
    
    <form action="action/do_add.jsp" method="post" enctype="multipart/form-data">
        產品名稱: <input type="text" name="ProductName" required><br><br>
        分類: <input type="text" name="Category" value="fresh" required><br><br>
        價格: <input type="number" name="Price" required><br><br>
        描述: <textarea name="Description" rows="5" cols="50"></textarea><br><br>
        
        <strong>本機圖片上傳:</strong><br>
        <input type="file" name="Image" accept="image/*" required><br><br>
        
        <button type="submit">確認上架</button>
    </form>
    <br>
    <a href="index.jsp">← 返回產品列表</a>
</body>
</html>