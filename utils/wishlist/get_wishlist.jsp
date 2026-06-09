<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    // 1. 驗證登入
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("[]");
        return;
    }
    int memberID = (int) midObj;

    StringBuilder json = new StringBuilder("[");
    try {
        // 2. 獲取所有收藏
        String sql = "SELECT p.* FROM `wishlist` w " +
                     "JOIN `product` p ON w.ProductID = p.ProductID " +
                     "WHERE w.MemberID = ? " +
                     "ORDER BY p.ProductID ASC";
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, memberID);
        ResultSet rs = pstmt.executeQuery();

        boolean first = true;
        while (rs.next()) {
            int productID = rs.getInt("ProductID");
            String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
            String category = rs.getString("Category");
            double price = rs.getDouble("Price");
            String series = rs.getString("Series").replace("\\", "\\\\").replace("\"", "\\\"");

            // 3. 即時計算 Category 的 relativeIndex (確保圖片路徑正確)
            int relativeIndex = 1;
            String rankSql = "SELECT COUNT(*) AS `rank` FROM `product` WHERE `Category` = ? AND `ProductID` <= ?";
            PreparedStatement rankPstmt = con.prepareStatement(rankSql);
            rankPstmt.setString(1, category);
            rankPstmt.setInt(2, productID);
            ResultSet rankRs = rankPstmt.executeQuery();
            if (rankRs.next()) {
                relativeIndex = rankRs.getInt("rank");
            }

            if (!first) {
                json.append(",");
            }
            first = false;

            json.append(String.format(
                "{\"ProductID\":%d, \"ProductName\":\"%s\", \"Category\":\"%s\", \"Price\":%.2f, \"Series\":\"%s\", \"relativeIndex\":%d}",
                productID, productName, category, price, series, relativeIndex
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    json.append("]");
    out.print(json.toString());
%>