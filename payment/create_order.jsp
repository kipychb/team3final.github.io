<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    // 1. 驗證會員登入狀態
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("{\"status\":\"nologin\"}");
        return;
    }
    int memberID = (int) midObj;

    // 2. 獲取前端提交的資料
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String note = request.getParameter("note");
    String deliveryDate = request.getParameter("delivery_date");
    String address = request.getParameter("address");
    String orderType = request.getParameter("payment_method"); // 對應 orders 的 OrderType

    if (name == null || phone == null || address == null || orderType == null || 
        name.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty()) {
        out.print("{\"status\":\"missing_parameters\"}");
        return;
    }

    try {
        // 3. 獲取該會員當前購物車的所有商品，以供後續計算總額與細項寫入
        String cartSql = "SELECT c.ProductID, c.Quantity, p.Price, p.Quantity AS Stock " +
                         "FROM `cart` c " +
                         "JOIN `product` p ON c.ProductID = p.ProductID " +
                         "WHERE c.MemberID = ?";
        PreparedStatement cartPstmt = con.prepareStatement(cartSql);
        cartPstmt.setInt(1, memberID);
        ResultSet cartRs = cartPstmt.executeQuery();

        // 建立快取清單
        java.util.List<int[]> items = new java.util.ArrayList<>();
        double subtotal = 0;
        boolean outOfStock = false;

        while (cartRs.next()) {
            int pid = cartRs.getInt("ProductID");
            int qty = cartRs.getInt("Quantity");
            int price = cartRs.getInt("Price");
            int stock = cartRs.getInt("Stock");

            if (qty > stock) {
                outOfStock = true;
            }

            subtotal += price * qty;
            items.add(new int[]{pid, qty, price}); // ProductID, Quantity, Price
        }
        cartRs.close();
        cartPstmt.close();

        if (items.isEmpty()) {
            out.print("{\"status\":\"empty_cart\"}");
            return;
        }

        if (outOfStock) {
            out.print("{\"status\":\"out_of_stock\"}");
            return;
        }

        // 4. 開始資料庫 Transaction 交易控制 (防崩潰保護機制)
        con.setAutoCommit(false);

        double totalAmount = subtotal + 120; // 運費 120 元

        // 5. 插入主訂單 (orders Table)
        // 欄位包含: MemberID, OrderDate, OrderType, TotalAmount, OrderStatus
        String insertOrderSql = "INSERT INTO `orders` (`MemberID`, `OrderDate`, `OrderType`, `TotalAmount`, `OrderStatus`) VALUES (?, CURDATE(), ?, ?, '已付款')";
        PreparedStatement orderPstmt = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
        orderPstmt.setInt(1, memberID);
        orderPstmt.setString(2, orderType);
        orderPstmt.setDouble(3, totalAmount);
        orderPstmt.executeUpdate();

        // 取得自動生成的 OrderID
        ResultSet generatedKeys = orderPstmt.getGeneratedKeys();
        int generatedOrderID = -1;
        if (generatedKeys.next()) {
            generatedOrderID = generatedKeys.getInt(1);
        }
        generatedKeys.close();
        orderPstmt.close();

        if (generatedOrderID == -1) {
            throw new SQLException("無法取得訂單自增 ID (OrderID)");
        }

        // 6. 逐筆寫入訂單明細 (order_detail Table) 並且扣除商品庫存數
        String insertDetailSql = "INSERT INTO `order_detail` (`OrderID`, `ProductID`, `Quantity`, `Price`, `Subtotal`) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement detailPstmt = con.prepareStatement(insertDetailSql);

        String updateStockSql = "UPDATE `product` SET `Quantity` = `Quantity` - ? WHERE `ProductID` = ?";
        PreparedStatement stockPstmt = con.prepareStatement(updateStockSql);

        for (int[] item : items) {
            int pid = item[0];
            int qty = item[1];
            int price = item[2];
            double itemSubtotal = price * qty;

            // 寫入 detail
            detailPstmt.setInt(1, generatedOrderID);
            detailPstmt.setInt(2, pid);
            detailPstmt.setInt(3, qty);
            detailPstmt.setInt(4, price);
            detailPstmt.setDouble(5, itemSubtotal);
            detailPstmt.addBatch();

            // 扣除庫存
            stockPstmt.setInt(1, qty);
            stockPstmt.setInt(2, pid);
            stockPstmt.addBatch();
        }
        detailPstmt.executeBatch();
        stockPstmt.executeBatch();

        detailPstmt.close();
        stockPstmt.close();

        // 7. 清空該會員目前的購物車項目 (cart Table)
        String clearCartSql = "DELETE FROM `cart` WHERE `MemberID` = ?";
        PreparedStatement clearPstmt = con.prepareStatement(clearCartSql);
        clearPstmt.setInt(1, memberID);
        clearPstmt.executeUpdate();
        clearPstmt.close();

        // 8. 提交交易
        con.commit();
        con.setAutoCommit(true);

        // 輸出 JSON 成功結果與漂亮的訂單編號
        String orderNumber = "ORD-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + String.format("%04d", generatedOrderID);
        out.print("{\"status\":\"success\", \"order_id\":" + generatedOrderID + ", \"order_number\":\"" + orderNumber + "\"}");

    } catch (Exception e) {
        try {
            con.rollback(); // 發生錯誤時完整回滾，保護資料庫安全
            con.setAutoCommit(true);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
%>