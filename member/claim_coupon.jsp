<%@ page contentType="application/json;charset=utf-8" language="java" import="java.sql.*" %>
    <%@ include file="../utils/config.jsp" %>

        <% Object midObj=session.getAttribute("mid"); if (midObj==null) {
            out.print("{\"status\":\"error\",\"message\":\"請先登入\"}"); return; } int
            mid=Integer.parseInt(midObj.toString()); try { String
            checkSql="SELECT id FROM member_coupons WHERE member_id=?" ; PreparedStatement
            ps=con.prepareStatement(checkSql); ps.setInt(1, mid); ResultSet rs=ps.executeQuery(); if (rs.next()) {
            out.print("{\"status\":\"already\",\"message\":\"已領取\"}"); } else { String
            insertSql="INSERT INTO member_coupons(member_id,coupon_amount,status) VALUES(?,150,'未使用')" ;
            PreparedStatement ins=con.prepareStatement(insertSql); ins.setInt(1, mid); ins.executeUpdate();
            out.print("{\"status\":\"success\",\"message\":\"領取成功\"}"); ins.close(); } rs.close(); ps.close(); } catch
            (Exception e) { out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\" }"); } %>