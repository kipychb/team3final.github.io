<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    StringBuilder json = new StringBuilder("[");
    try {
        // 1. 查詢所有商品，以便前端進行即時花語搜尋
        String sql = "SELECT `ProductID`, `ProductName`, `Category`, `Language` FROM `product` ORDER BY `ProductID` ASC";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        boolean first = true;
        while (rs.next()) {
            int productID = rs.getInt("ProductID");
            // 逸出處理，防止 JSON 格式毀損
            String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
            String category = rs.getString("Category");
            String language = rs.getString("Language");
            if (language == null) {
                language = "";
            } else {
                language = language.replace("\\", "\\\\").replace("\"", "\\\"");
            }

            // 2. 即時計算 Category 的 relativeIndex (確保圖片路徑正確)
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
                "{\"ProductID\":%d, \"ProductName\":\"%s\", \"Category\":\"%s\", \"Language\":\"%s\", \"relativeIndex\":%d}",
                productID, productName, category, language, relativeIndex
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