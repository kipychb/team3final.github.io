<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("{\"status\":\"nologin\"}");
        return;
    }
    int memberID = (int) midObj;

    try {
        String sql = "SELECT `MemberName`, `Phone`, `Address`, `Birthday` FROM `member` WHERE `MemberID` = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String name = rs.getString("MemberName");
            String phone = rs.getString("Phone");
            String address = rs.getString("Address");
            String birthday = rs.getString("Birthday");

            // 防呆空值處理
            if (name == null) name = "";
            if (phone == null) phone = "";
            if (address == null) address = "";
            if (birthday == null) birthday = "";

            out.print(String.format(
            "{\"status\":\"success\", \"name\":\"%s\", \"phone\":\"%s\", \"address\":\"%s\", \"birthday\":\"%s\"}",
            name.replace("\\", "\\\\").replace("\"", "\\\""),
            phone.replace("\\", "\\\\").replace("\"", "\\\""),
            address.replace("\\", "\\\\").replace("\"", "\\\""),
            birthday.replace("\\", "\\\\").replace("\"", "\\\"")
            ));
        } else {
            out.print("{\"status\":\"not_found\"}");
        }
        rs.close();
        pstmt.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
%>