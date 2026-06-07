<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>

<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String orderIdStr = request.getParameter("OrderID");
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch(Exception e) {
        out.println("<script>alert('無效的訂單ID！'); history.back();</script>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>訂單明細 - <%= orderId %></title>
    <link rel="stylesheet" href="../style.css">
</head>
<body style="padding:30px; background:#eeebe2;">
    <h2>📦 訂單明細 (訂單編號：<%= orderId %>)</h2>
    <a href="order.jsp">← 返回訂單列表</a><br><br>

    <table border="1" width="100%" style="border-collapse:collapse; background:white;">
        <tr style="background:#A3A69C; color:white;">
            <th>商品ID</th>
            <th>商品名稱</th>
            <th>單價</th>
            <th>數量</th>
            <th>小計</th>
        </tr>
        <%
            try {
                Connection dbCon = (Connection) request.getAttribute("con");
                if (dbCon != null) {
                    // 取得訂單明細 + 商品名稱
                    String sql = "SELECT od.*, p.ProductName FROM order_detail od " +
                                 "LEFT JOIN product p ON od.ProductID = p.ProductID " +
                                 "WHERE od.OrderID = ? ORDER BY od.ProductID";
                    PreparedStatement pstmt = dbCon.prepareStatement(sql);
                    pstmt.setInt(1, orderId);
                    ResultSet rs = pstmt.executeQuery();
                    
                    while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("ProductID") %></td>
            <td><%= rs.getString("ProductName") != null ? rs.getString("ProductName") : "商品已刪除" %></td>
            <td>$<%= rs.getInt("Price") %></td>
            <td><%= rs.getInt("Quantity") %></td>
            <td>$<%= rs.getBigDecimal("Subtotal") %></td>
        </tr>
        <% 
                    }
                    rs.close();
                    pstmt.close();
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>錯誤: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>