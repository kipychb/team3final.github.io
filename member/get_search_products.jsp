<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");

    StringBuilder json = new StringBuilder("[");
    try {
        // 1. 查詢所有商品，以便前端進行即時花語搜尋
        String sql = "SELECT `ProductID`, `ProductName`, `Category`, `Language`, `Image` FROM `product` ORDER BY `ProductID` ASC";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        boolean first = true;
        while (rs.next()) {
            int productID = rs.getInt("ProductID");
            // 逸出處理，防止 JSON 格式毀損
            String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
            String category = rs.getString("Category");
            String language = rs.getString("Language");
            if (language == null) language = "";
            else language = language.replace("\\", "\\\\").replace("\"", "\\\"");
            String image = rs.getString("Image");
            if (image == null) image = "";
            else image = image.replace("\\", "\\\\").replace("\"", "\\\"");

            if (!first) json.append(",");
            first = false;

            json.append(String.format(
                "{\"ProductID\":%d,\"ProductName\":\"%s\",\"Category\":\"%s\",\"Language\":\"%s\",\"Image\":\"%s\"}",
                productID, productName, category, language, image
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