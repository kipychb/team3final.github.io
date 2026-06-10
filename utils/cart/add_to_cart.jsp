<%@page contentType="text/plain;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // 1. 驗證會員登入狀態
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("nologin");
        return;
    }
    int memberID = (int) midObj;

    // 2. 獲取傳入參數
    String productIDStr = request.getParameter("product_id");
    String qtyStr = request.getParameter("qty");

    if (productIDStr == null || productIDStr.trim().isEmpty()) {
        out.print("missing_parameters");
        return;
    }

    int qty = 1;
    if (qtyStr != null && !qtyStr.trim().isEmpty()) {
        try {
            qty = Integer.parseInt(qtyStr);
        } catch (NumberFormatException e) {
            qty = 1;
        }
    }

    try {
        int productID = Integer.parseInt(productIDStr);

        // 3. 檢查購物車中是否已經有這件商品 (欄位改為 Quantity)
        String checkSql = "SELECT `Quantity` FROM `cart` WHERE `MemberID` = ? AND `ProductID` = ?";
        PreparedStatement checkPstmt = con.prepareStatement(checkSql);
        checkPstmt.setInt(1, memberID);
        checkPstmt.setInt(2, productID);
        ResultSet checkRs = checkPstmt.executeQuery();

        if (checkRs.next()) {
            // 商品已存在，累加 Quantity
            int currentQty = checkRs.getInt("Quantity");
            int newQty = currentQty + qty;

            String updateSql = "UPDATE `cart` SET `Quantity` = ? WHERE `MemberID` = ? AND `ProductID` = ?";
            PreparedStatement updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setInt(1, newQty);
            updatePstmt.setInt(2, memberID);
            updatePstmt.setInt(3, productID);
            updatePstmt.executeUpdate();
            updatePstmt.close();
        } else {
            // 商品不存在，全新新增一筆 (欄位為 Quantity)
            String insertSql = "INSERT INTO `cart` (`MemberID`, `ProductID`, `Quantity`) VALUES (?, ?, ?)";
            PreparedStatement insertPstmt = con.prepareStatement(insertSql);
            insertPstmt.setInt(1, memberID);
            insertPstmt.setInt(2, productID);
            insertPstmt.setInt(3, qty);
            insertPstmt.executeUpdate();
            insertPstmt.close();
        }
        
        checkRs.close();
        checkPstmt.close();
        out.print("success");
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error: " + e.getMessage());
    }
%>