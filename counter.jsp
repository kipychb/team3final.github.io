<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="utils/config.jsp"%>
<%
    int visitCount = 0;
    
    // 1. 查詢當前計數器數值
    String selectSql = "SELECT `visitCount` FROM `counter` LIMIT 1";
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(selectSql);
    
    if (rs.next()) {
        visitCount = rs.getInt("visitCount");
    }
    
    // 2. 利用 session.isNew() 判斷是否為新訪客
    if (session.isNew()) {
        visitCount++; // 記憶體中先加 1
        
        // 更新資料庫中的計數器數值
        String updateSql = "UPDATE `counter` SET `visitCount` = ?";
        PreparedStatement pstmt = con.prepareStatement(updateSql);
        pstmt.setInt(1, visitCount);
        pstmt.executeUpdate();
    }
%>