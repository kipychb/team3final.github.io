<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
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
        // 2. 聯表查詢 (JOIN) 購物車項目、商品資訊與分類
        String sql = "SELECT c.ProductID, c.Quantity, p.ProductName, p.Price, p.Category " +
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
            String category = rs.getString("Category");

            // 3. 即時計算 Category 的 relativeIndex (確保縮圖路徑正確)
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

            if (!first) {
                json.append(",");
            }
            first = false;

            json.append(String.format(
                "{\"ProductID\":%d, \"Quantity\":%d, \"ProductName\":\"%s\", \"Price\":%.2f, \"Category\":\"%s\", \"relativeIndex\":%d}",
                productID, quantity, productName, price, category, relativeIndex
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