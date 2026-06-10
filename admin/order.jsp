<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>

<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>所有訂單管理</title>
    <link rel="stylesheet" href="../style.css">
</head>
<body style="padding:30px; background:#eeebe2;">
    <h2>📋 所有會員訂單</h2>
    <a href="index.jsp">← 返回後台</a><br><br>

    <table border="1" width="100%" style="border-collapse:collapse; background:white;">
        <tr style="background:#A3A69C; color:white;">
            <th>訂單ID</th>
            <th>會員</th>
            <th>總金額</th>
            <th>訂單日期</th>
            <th>狀態</th>
            <th>操作</th>
        </tr>
        <%
            try {
                Connection dbCon = (Connection) request.getAttribute("con");
                
                if (dbCon == null) {
                    out.println("<tr><td colspan='6' style='color:red;'>❌ 資料庫連線失敗</td></tr>");
                } else {
                    String sql = "SELECT o.*, m.MemberName FROM orders o JOIN member m ON o.MemberID = m.MemberID ORDER BY o.OrderID DESC";
                    Statement stmt = dbCon.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("OrderID") %></td>
            <td><%= rs.getString("MemberName") %></td>
            <td>$<%= rs.getBigDecimal("TotalAmount") %></td>
            <td><%= rs.getDate("OrderDate") %></td>
            <td><%= rs.getString("OrderStatus") != null ? rs.getString("OrderStatus") : "已付款" %></td>
            <td>
                <a href="order_detail.jsp?OrderID=<%= rs.getInt("OrderID") %>" style="color:#705844; font-weight:bold;">查看明細</a>
            </td>
        </tr>
        <% 
                    }
                    rs.close(); 
                    stmt.close();
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='6' style='color:red;'>錯誤: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>