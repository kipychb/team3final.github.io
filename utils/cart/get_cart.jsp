<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    // 1. 驗證會員登入狀態
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("[]");
        return;
    }
    int memberID = (int) midObj;

    StringBuilder json = new StringBuilder("[");
    try {
        // 2. 聯表查詢 (將原先的 Qty 改為 Quantity)
        String sql = "SELECT c.ProductID, c.Quantity, p.ProductName, p.Price " +
                     "FROM `cart` c " +
                     "JOIN `product` p ON c.ProductID = p.ProductID " +
                     "WHERE c.MemberID = ? " +
                     "ORDER BY c.ProductID DESC";
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        ResultSet rs = pstmt.executeQuery();

        boolean first = true;
        while (rs.next()) {
            int productID = rs.getInt("ProductID");
            int quantity = rs.getInt("Quantity");
            String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
            double price = rs.getDouble("Price");

            if (!first) {
                json.append(",");
            }
            first = false;

            // 輸出變數也對應改為 Quantity
            json.append(String.format(
                "{\"ProductID\":%d, \"Quantity\":%d, \"ProductName\":\"%s\", \"Price\":%.2f}",
                productID, quantity, productName, price
            ));
        }
        rs.close();
        pstmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    json.append("]");
    out.print(json.toString());
%>