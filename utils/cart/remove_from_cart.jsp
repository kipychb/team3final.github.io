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

    // 2. 獲取傳入的 product_id 參數
    String productIDStr = request.getParameter("product_id");
    if (productIDStr == null || productIDStr.trim().isEmpty()) {
        out.print("missing_parameters");
        return;
    }

    try {
        int productID = Integer.parseInt(productIDStr);

        // 3. 執行刪除動作 (利用 MemberID 與 ProductID 雙PK定位)
        String deleteSql = "DELETE FROM `cart` WHERE `MemberID` = ? AND `ProductID` = ?";
        PreparedStatement pstmt = con.prepareStatement(deleteSql);
        pstmt.setInt(1, memberID);
        pstmt.setInt(2, productID);
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();

        if (rowsAffected > 0) {
            out.print("success");
        } else {
            out.print("not_found");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error: " + e.getMessage());
    }
%>