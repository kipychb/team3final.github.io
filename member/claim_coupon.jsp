<%@page contentType="application/json;charset=utf-8" import="java.sql.*" %>
    <%@include file="../utils/config.jsp" %>
        <% Object midObj=session.getAttribute("mid"); if (midObj==null) { out.print("{\"status\":\"error\",
            \"message\":\"請先登入\"}"); return; } int mid=Integer.parseInt(midObj.toString()); try (Connection
            conn=DriverManager.getConnection(dbUrl, dbUser, dbPass)) { // 檢查是否已領取 PreparedStatement
            ps=conn.prepareStatement("SELECT id FROM member_coupons WHERE member_id=?"); ps.setInt(1, mid); ResultSet
            rs=ps.executeQuery(); if (rs.next()) { out.print("{\"status\":\"already\", \"message\":\"您已經領取過了！\"}"); }
            else { // 寫入資料庫 PreparedStatement ins=conn.prepareStatement("INSERT INTO member_coupons (member_id) VALUES
            (?)"); ins.setInt(1, mid); ins.executeUpdate(); out.print("{\"status\":\"success\",
            \"message\":\"領取成功！已存入您的帳戶。\"}"); } } catch (Exception e) { out.print("{\"status\":\"error\",
            \"message\":\"系統錯誤\"}"); } %>