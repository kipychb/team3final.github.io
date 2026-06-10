<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    // 權限檢查
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
                if (con == null) {
                    out.println("<tr><td colspan='6' style='color:red; padding: 10px;'>❌ 資料庫連線失敗，請檢查 config.jsp</td></tr>");
                } else {
                    // 為了確保跟前台讀取順序一致，使用 ProductID ASC 排序
                    String sql = "SELECT * FROM product ORDER BY ProductID ASC";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    int freshIdx = 0;
                    int driedIdx = 0;
                    
                    while(rs.next()) {
                        int pId = rs.getInt("ProductID");
                        String category = rs.getString("Category");
                        String imgUrl = rs.getString("Image");
                        String finalImgPath = "";

                        // 計算舊資料的流水號
                        if ("fresh".equals(category)) { freshIdx++; } else { driedIdx++; }

                        // 🔍 核心精準圖片路徑判定
                        if (imgUrl != null && !imgUrl.trim().isEmpty() && !imgUrl.trim().equalsIgnoreCase("null")) {
                            imgUrl = imgUrl.trim();
                            
                            if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
                                // 情況 A：如果是網路圖片
                                finalImgPath = imgUrl;
                            } else if (imgUrl.contains("/") || imgUrl.endsWith("-2.jpg")) {
                                // 情況 B：如果資料庫裡本來就存了路徑或特定的舊檔名（例如 flower/fresh/1-2.jpg）
                                if (imgUrl.startsWith("image/")) {
                                    finalImgPath = "../" + imgUrl;
                                } else {
                                    finalImgPath = "../image/" + imgUrl;
                                }
                            } else {
                                // 情況 C：如果是新上架產生的 UUID 檔名（例如 36d4ff....jpg），它儲存在 image/images/ 內
                                finalImgPath = "../image/images/" + imgUrl;
                            }
                        } else {
                            // 情況 D：如果資料庫完全沒有圖片資料，走備用流水號圖防止破圖
                            if ("fresh".equals(category)) {
                                finalImgPath = "../image/flower/fresh/" + freshIdx + "-2.jpg";
                            } else {
                                finalImgPath = "../image/flower/dried/" + driedIdx + "-2.jpg";
                            }
                        }
        %>
        <tr>
            <td style="padding: 10px;"><%= pId %></td>
            <td style="padding: 10px;">
                <img src="<%= finalImgPath %>" width="80" height="80" style="object-fit: cover; border-radius: 4px; background: #eaeaea; display: block;" onerror="this.onerror=null; this.src='../image/flower/fresh/1-2.jpg';">
            </td>
            <td style="padding: 10px; font-weight: bold;"><%= rs.getString("ProductName") %></td>
            <td style="padding: 10px;"><%= category %></td>
            <td style="padding: 10px; color: #705844;">$<%= rs.getInt("Price") %></td>
            <td style="padding: 10px;">
                <a href="product_edit.jsp?id=<%= pId %>" style="color: #705844; text-decoration: none; margin-right: 10px;">✏️ 修改</a>
                <a href="action/do_delete.jsp?id=<%= pId %>" onclick="return confirm('確定要刪除此產品？')" style="color: red; text-decoration: none;">🗑️ 刪除</a>
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