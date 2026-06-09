<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../../utils/config.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        out.println("<script>alert('權限不足！'); window.location.href='../../index.jsp';</script>");
        return;
    }

    String id = request.getParameter("ProductID");
    String productName = request.getParameter("ProductName");
    String category = request.getParameter("Category");
    String priceStr = request.getParameter("Price");
    String description = request.getParameter("Description");
    String image = request.getParameter("Image"); // 💡 1. 接收前端傳過來的 Image 參數

    // 強力防護
    if (id == null || productName == null || productName.trim().isEmpty()) {
        out.println("<script>alert('錯誤：缺少必要資料（產品ID或名稱）！'); history.back();</script>");
        return;
    }

    int price = 0;
    try {
        if (priceStr != null && !priceStr.trim().isEmpty() && !priceStr.trim().equals("null")) {
            price = Integer.parseInt(priceStr.trim());
        }
    } catch(Exception e) {
        price = 0; // 預設值
    }

    try {
        if (con == null) {
            out.println("<script>alert('資料庫連線失敗！'); history.back();</script>");
            return;
        }

        // 💡 2. SQL 指令補上 Image=?
        String sql = "UPDATE product SET ProductName=?, Category=?, Price=?, Idea=?, Image=? WHERE ProductID=?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productName.trim());
        pstmt.setString(2, category != null ? category.trim() : "fresh");
        pstmt.setInt(3, price);
        pstmt.setString(4, description != null ? description.trim() : "");
        pstmt.setString(5, (image != null && !image.trim().isEmpty()) ? image.trim() : null); // 💡 3. 將圖片值塞入（若留空就存 null）
        pstmt.setInt(6, Integer.parseInt(id));
        
        int result = pstmt.executeUpdate();
        pstmt.close();
        
        if (result > 0) {
            out.println("<script>alert('✅ 修改成功！'); window.location.href='../index.jsp';</script>");
        } else {
            out.println("<script>alert('修改失敗：找不到該產品！'); history.back();</script>");
        }
    } catch(Exception e) {
        out.println("<script>alert('修改失敗: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
    }
%>