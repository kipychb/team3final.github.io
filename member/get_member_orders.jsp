<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*, java.text.SimpleDateFormat"%>
<%@include file="../utils/config.jsp" %>
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
        // 2. 查詢該會員的所有訂單 (依 OrderID 降冪排序，最新訂單在最上面)
        String orderSql = "SELECT `OrderID`, `OrderDate`, `OrderType`, `TotalAmount`, `OrderStatus` FROM `orders` WHERE `MemberID` = ? ORDER BY `OrderID` DESC";
        PreparedStatement orderPstmt = con.prepareStatement(orderSql);
        orderPstmt.setInt(1, memberID);
        ResultSet orderRs = orderPstmt.executeQuery();

        boolean firstOrder = true;
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat displayDf = new SimpleDateFormat("yyyy/MM/dd");

        while (orderRs.next()) {
            int orderID = orderRs.getInt("OrderID");
            Date orderDate = orderRs.getDate("OrderDate");
            String orderType = orderRs.getString("OrderType");
            double totalAmount = orderRs.getDouble("TotalAmount");
            String orderStatus = orderRs.getString("OrderStatus");

            // 產生 ORD-YYYYMMDDXXXX 格式的訂單編號
            String orderDateStr = (orderDate != null) ? df.format(orderDate) : "00000000";
            String displayDateStr = (orderDate != null) ? displayDf.format(orderDate) : "未知日期";
            String orderNumber = "ORD-" + orderDateStr + String.format("%04d", orderID);

            if (!firstOrder) {
                json.append(",");
            }
            firstOrder = false;

            json.append("{");
            json.append(String.format(
                "\"OrderID\":%d, \"OrderNumber\":\"%s\", \"OrderDate\":\"%s\", \"OrderType\":\"%s\", \"TotalAmount\":%.2f, \"OrderStatus\":\"%s\", \"Details\":[",
                orderID, orderNumber, displayDateStr, orderType, totalAmount, orderStatus
            ));

            // 3. 聯表查詢該訂單下的所有商品明細與 relativeIndex 圖片路徑所需欄位
            String detailSql = "SELECT od.ProductID, od.Quantity, od.Price, od.Subtotal, p.ProductName, p.Category " +
                               "FROM `order_detail` od " +
                               "JOIN `product` p ON od.ProductID = p.ProductID " +
                               "WHERE od.OrderID = ?";
            PreparedStatement detailPstmt = con.prepareStatement(detailSql);
            detailPstmt.setInt(1, orderID);
            ResultSet detailRs = detailPstmt.executeQuery();

            boolean firstDetail = true;
            while (detailRs.next()) {
                int productID = detailRs.getInt("ProductID");
                int quantity = detailRs.getInt("Quantity");
                double price = detailRs.getDouble("Price");
                double subtotal = detailRs.getDouble("Subtotal");
                String productName = detailRs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
                String category = detailRs.getString("Category");

                // 即時計算 Category 的 relativeIndex (確保圖片路徑正確)
                int relativeIndex = 1;
                String rankSql = "SELECT COUNT(*) AS `rank` FROM `product` WHERE `Category` = ? AND `ProductID` <= ?";
                PreparedStatement rankPstmt = con.prepareStatement(rankSql);
                rankPstmt.setString(1, category);
                rankPstmt.setInt(2, productID);
                ResultSet rankRs = rankPstmt.executeQuery();
                if (rankRs.next()) {
                    relativeIndex = rankRs.getInt("rank");
                }
                rankRs.close();
                rankPstmt.close();

                if (!firstDetail) {
                    json.append(",");
                }
                firstDetail = false;

                json.append(String.format(
                    "{\"ProductID\":%d, \"Quantity\":%d, \"Price\":%.2f, \"Subtotal\":%.2f, \"ProductName\":\"%s\", \"Category\":\"%s\", \"relativeIndex\":%d}",
                    productID, quantity, price, subtotal, productName, category, relativeIndex
                ));
            }
            detailRs.close();
            detailPstmt.close();

            json.append("]}");
        }
        orderRs.close();
        orderPstmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    json.append("]");
    out.print(json.toString());
%>