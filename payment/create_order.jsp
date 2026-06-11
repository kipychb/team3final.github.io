<%@ page contentType="application/json;charset=utf-8" language="java" import="java.sql.*, java.util.*, java.text.*" %>
<%@ include file="../utils/config.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");
    
    Object midObj = session.getAttribute("mid");
    if (midObj == null) { 
        out.print("{\"status\":\"nologin\"}");
        return;
    }

    int memberID = Integer.parseInt(midObj.toString());
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String orderType = request.getParameter("payment_method");
    String couponIdParam = request.getParameter("coupon_id");
    
    if (name == null || phone == null || address == null || orderType == null || name.trim().equals("") || phone.trim().equals("") || address.trim().equals("")) {
        out.print("{\"status\":\"missing_parameters\"}");
        return;
    }

    int couponId = 0;
    if (couponIdParam != null && !couponIdParam.trim().equals("")) {
        couponId = Integer.parseInt(couponIdParam.trim());
    } 

    try { 
        String cartSql = "SELECT c.ProductID, c.Quantity, p.Price, p.Quantity AS Stock FROM cart c JOIN product p ON c.ProductID = p.ProductID WHERE c.MemberID = ?";
        PreparedStatement cartPstmt = con.prepareStatement(cartSql);
        cartPstmt.setInt(1, memberID);
        ResultSet cartRs = cartPstmt.executeQuery();
        
        ArrayList<int[]> items = new ArrayList<int[]>();
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
            items.add(new int[]{pid, qty, price});
        }

        cartRs.close();
        cartPstmt.close();

        if (items.size() == 0) {
            out.print("{\"status\":\"empty_cart\"}");
            return;
        }

        if (outOfStock) {
            out.print("{\"status\":\"out_of_stock\"}");
            return;
        }

        con.setAutoCommit(false);

        double shippingFee = 120;
        double discountAmount = 0;

        if (couponId > 0) {
            String couponSql = "SELECT coupon_amount FROM member_coupons WHERE id = ? AND member_id = ? AND status = '未使用'";

            PreparedStatement couponPstmt = con.prepareStatement(couponSql);
            couponPstmt.setInt(1, couponId);
            couponPstmt.setInt(2, memberID);
            ResultSet couponRs = couponPstmt.executeQuery();

            if (couponRs.next()) {
                discountAmount = couponRs.getInt("coupon_amount");
            } else {
                couponRs.close();
                couponPstmt.close();
                con.rollback();
                con.setAutoCommit(true);
                out.print("{\"status\":\"invalid_coupon\"}");
                return;
            }

            couponRs.close();
            couponPstmt.close();
        }

        double totalAmount = subtotal + shippingFee - discountAmount;

        if (totalAmount < 0) { 
            totalAmount = 0;
        } 

        String insertOrderSql = "INSERT INTO orders (MemberID, OrderDate, OrderType, TotalAmount, OrderStatus) VALUES (?, CURDATE(), ?, ?, '已付款')";
        PreparedStatement orderPstmt = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
        orderPstmt.setInt(1, memberID);
        orderPstmt.setString(2, orderType);
        orderPstmt.setDouble(3, totalAmount);
        orderPstmt.executeUpdate();
        
        ResultSet keys = orderPstmt.getGeneratedKeys();
        int orderID = -1;
        if (keys.next()) { 
            orderID = keys.getInt(1);
        } 
        keys.close();
        orderPstmt.close();
        
        if (orderID == -1) { 
            throw new SQLException("無法取得訂單編號");
        } 

        String detailSql = "INSERT INTO order_detail (OrderID, ProductID, Quantity, Price, Subtotal) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement detailPstmt = con.prepareStatement(detailSql);
        
        String stockSql = "UPDATE product SET Quantity = Quantity - ? WHERE ProductID = ?";
        PreparedStatement stockPstmt = con.prepareStatement(stockSql);
        
        for (int[] item : items) { 
            int pid = item[0];
            int qty = item[1];
            int price = item[2];
            
            detailPstmt.setInt(1, orderID);
            detailPstmt.setInt(2, pid);
            detailPstmt.setInt(3, qty);
            detailPstmt.setInt(4, price);
            detailPstmt.setDouble(5, price * qty);
            detailPstmt.addBatch();
            
            stockPstmt.setInt(1, qty);
            stockPstmt.setInt(2, pid);
            stockPstmt.addBatch();
        } 
        
        detailPstmt.executeBatch();
        stockPstmt.executeBatch();
        detailPstmt.close();
        stockPstmt.close();
        
        if (couponId > 0) {
            String updateCouponSql = "UPDATE member_coupons SET status = '已使用' WHERE id = ? AND member_id = ?";
            PreparedStatement updateCouponPstmt = con.prepareStatement(updateCouponSql);
            updateCouponPstmt.setInt(1, couponId);
            updateCouponPstmt.setInt(2, memberID);
            updateCouponPstmt.executeUpdate();
            updateCouponPstmt.close();
        }

        String clearCartSql = "DELETE FROM cart WHERE MemberID = ?";
        PreparedStatement clearPstmt = con.prepareStatement(clearCartSql);
        clearPstmt.setInt(1, memberID);
        clearPstmt.executeUpdate();
        clearPstmt.close();

        con.commit();
        con.setAutoCommit(true);

        String orderNumber = "ORD-" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + String.format("%04d", orderID);

        out.print("{\"status\":\"success\",\"order_id\":" + orderID + ",\"order_number\":\"" + orderNumber + "\"}");

    } catch (Exception e) {
        try {
            con.rollback();
            con.setAutoCommit(true);
        } catch (Exception ex) {}

        String msg = e.getMessage();
        if (msg == null) {
            msg = "unknown error";
        }

        out.print("{\"status\":\"error\",\"message\":\"" + msg.replace("\\", "\\\\").replace("\"", "\\\"") + "\"}");
    }
%>