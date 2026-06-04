<%@page contentType="text/plain;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // 1. 驗證登入
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("nologin");
        return;
    }
    int memberID = (int) midObj;

    String productIDStr = request.getParameter("product_id");
    if (productIDStr == null || productIDStr.trim().isEmpty()) {
        out.print("missing_parameters");
        return;
    }

    try {
        int productID = Integer.parseInt(productIDStr);

        // 2. 檢查是否已經收藏
        String checkSql = "SELECT COUNT(*) FROM `wishlist` WHERE `MemberID` = ? AND `ProductID` = ?";
        PreparedStatement checkPstmt = con.prepareStatement(checkSql);
        checkPstmt.setInt(1, memberID);
        checkPstmt.setInt(2, productID);
        ResultSet checkRs = checkPstmt.executeQuery();
        checkRs.next();
        int count = checkRs.getInt(1);

        if (count > 0) {
            // 已有收藏則移除
            String deleteSql = "DELETE FROM `wishlist` WHERE `MemberID` = ? AND `ProductID` = ?";
            PreparedStatement deletePstmt = con.prepareStatement(deleteSql);
            deletePstmt.setInt(1, memberID);
            deletePstmt.setInt(2, productID);
            deletePstmt.executeUpdate();
            out.print("removed");
        } else {
            // 未收藏則新增
            String insertSql = "INSERT INTO `wishlist` (`MemberID`, `ProductID`) VALUES (?, ?)";
            PreparedStatement insertPstmt = con.prepareStatement(insertSql);
            insertPstmt.setInt(1, memberID);
            insertPstmt.setInt(2, productID);
            insertPstmt.executeUpdate();
            out.print("added");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error: " + e.getMessage());
    }
%>