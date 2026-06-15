<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // 1. 檢查使用者 Session 是否已登入
    Object midObj = session.getAttribute("mid");
    String productID = request.getParameter("product_id");
    if (midObj == null) {
        response.sendRedirect("../member/login/index.jsp");
        return;
    }
    int memberID = (int) midObj;

    // 2. 獲取前端參數
    String ratingStr = request.getParameter("rating");
    String contents = request.getParameter("contents");

    String safeId = (productID != null && !productID.trim().isEmpty()) ? productID.trim() : "0";

    if (productID == null || ratingStr == null || contents == null) {
        response.sendRedirect("index.jsp?id=" + safeId + "&review=error");
        return;
    }

    try {
        double rating = Double.parseDouble(ratingStr);
        if (rating <= 0) {
            response.sendRedirect("index.jsp?id=" + safeId + "&review=error");
            return;
        }

        String sql = "INSERT INTO `guestbook` (`MemberID`, `ProductID`, `Rating`, `Contents`, `DateTime`) VALUES (?, ?, ?, ?, NOW())";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        pstmt.setString(2, productID);
        pstmt.setDouble(3, rating);
        pstmt.setString(4, contents);

        int rows = pstmt.executeUpdate();
        response.sendRedirect("index.jsp?id=" + safeId + (rows > 0 ? "&review=success" : "&review=error"));
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp?id=" + safeId + "&review=error");
    }
%>