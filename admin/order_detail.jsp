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
    } catch (Exception e) {
        out.println("<script>alert('無效的訂單ID！'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>訂單明細 #<%= orderId %> — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">訂單明細</h1>
        <span class="admin-subtitle">訂單編號：#<%= orderId %></span>
    </div>

    <a class="admin-back-link" href="order.jsp">← 返回訂單列表</a>

    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>商品 ID</th>
                    <th>商品名稱</th>
                    <th>單價</th>
                    <th>數量</th>
                    <th>小計</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    if (con != null) {
                        String sql = "SELECT od.*, p.ProductName FROM order_detail od " +
                                     "LEFT JOIN product p ON od.ProductID = p.ProductID " +
                                     "WHERE od.OrderID = ? ORDER BY od.ProductID";
                        PreparedStatement pstmt = con.prepareStatement(sql);
                        pstmt.setInt(1, orderId);
                        ResultSet rs = pstmt.executeQuery();

                        boolean hasRow = false;
                        while (rs.next()) {
                            hasRow = true;
                            String pname = rs.getString("ProductName");
                            if (pname == null) pname = "（商品已刪除）";
            %>
                <tr>
                    <td class="col-id"><%= rs.getInt("ProductID") %></td>
                    <td><%= pname %></td>
                    <td class="col-price">NT$ <%= String.format("%,d", rs.getInt("Price")) %></td>
                    <td><%= rs.getInt("Quantity") %></td>
                    <td class="col-price">NT$ <%= String.format("%,d", rs.getBigDecimal("Subtotal").intValue()) %></td>
                </tr>
            <%
                        }
                        if (!hasRow) {
            %>
                <tr><td colspan="5" class="admin-empty">此訂單沒有商品明細</td></tr>
            <%
                        }
                        rs.close(); pstmt.close();
                    } else {
            %>
                <tr class="table-error"><td colspan="5">❌ 資料庫連線失敗</td></tr>
            <%
                    }
                } catch (Exception e) {
            %>
                <tr class="table-error"><td colspan="5">錯誤：<%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
