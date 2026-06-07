<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // 1. 檢查使用者 Session 是否已登入
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("nologin");
        return;
    }
    int memberID = (int) midObj;

    // 2. 獲取前端參數
    String productID = request.getParameter("product_id");
    String ratingStr = request.getParameter("rating");
    String contents = request.getParameter("contents");

    if (productID == null || ratingStr == null || contents == null) {
        out.print("missing_parameters");
        return;
    }

    try {
        double rating = Double.parseDouble(ratingStr);

        // 3. 寫入 guestbook 資料表
        String sql = "INSERT INTO `guestbook` (`MemberID`, `ProductID`, `Rating`, `Contents`, `DateTime`) VALUES (?, ?, ?, ?, NOW())";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        pstmt.setString(2, productID);
        pstmt.setDouble(3, rating);
        pstmt.setString(4, contents);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("success");
        } else {
            out.print("fail");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>