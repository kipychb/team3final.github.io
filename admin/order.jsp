<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>所有訂單 — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">所有會員訂單</h1>
    </div>

    <a class="admin-back-link" href="index.jsp">← 返回後台首頁</a>

    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>訂單 ID</th>
                    <th>會員名稱</th>
                    <th>總金額</th>
                    <th>訂單日期</th>
                    <th>狀態</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    if (con == null) {
            %>
                <tr class="table-error"><td colspan="6">❌ 資料庫連線失敗</td></tr>
            <%
                    } else {
                        String sql = "SELECT o.*, m.MemberName FROM orders o " +
                                     "JOIN member m ON o.MemberID = m.MemberID ORDER BY o.OrderID DESC";
                        Statement stmt = con.createStatement();
                        ResultSet rs   = stmt.executeQuery(sql);

                        boolean hasRow = false;
                        while (rs.next()) {
                            hasRow = true;
                            String status = rs.getString("OrderStatus");
                            if (status == null) status = "已付款";

                            String tagClass = "status-tag";
                            if ("已付款".equals(status))  tagClass += " paid";
                            else if ("已出貨".equals(status)) tagClass += " shipped";
                            else if ("完成".equals(status))   tagClass += " done";
            %>
                <tr>
                    <td class="col-id"><%= rs.getInt("OrderID") %></td>
                    <td><%= rs.getString("MemberName") %></td>
                    <td class="col-price">NT$ <%= String.format("%,d", rs.getBigDecimal("TotalAmount").intValue()) %></td>
                    <td><%= rs.getDate("OrderDate") %></td>
                    <td><span class="<%= tagClass %>"><%= status %></span></td>
                    <td>
                        <a class="action-view" href="order_detail.jsp?OrderID=<%= rs.getInt("OrderID") %>">查看明細</a>
                    </td>
                </tr>
            <%
                        }
                        if (!hasRow) {
            %>
                <tr><td colspan="6" class="admin-empty">目前沒有任何訂單</td></tr>
            <%
                        }
                        rs.close(); stmt.close();
                    }
                } catch (Exception e) {
            %>
                <tr class="table-error"><td colspan="6">錯誤：<%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
