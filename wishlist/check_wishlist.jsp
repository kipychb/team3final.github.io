<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    // 回傳該會員所有已收藏的 ProductID
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("[]");
        return;
    }
    int memberID = (int) midObj;

    StringBuilder json = new StringBuilder("[");
    try {
        String sql = "SELECT `ProductID` FROM `wishlist` WHERE `MemberID` = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        ResultSet rs = pstmt.executeQuery();
        
        boolean first = true;
        while (rs.next()) {
            if (!first) {
                json.append(",");
            }
            first = false;
            json.append(rs.getInt("ProductID"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    json.append("]");
    out.print(json.toString());
%>