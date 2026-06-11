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
        String sql = "SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.Series, p.Image " +
                     "FROM `wishlist` w " +
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
            String series = rs.getString("Series");
            if (series == null) series = ""; else series = series.replace("\\", "\\\\").replace("\"", "\\\"");
            String image = rs.getString("Image");
            if (image == null) image = ""; else image = image.replace("\\", "\\\\").replace("\"", "\\\"");

            if (!first) json.append(",");
            first = false;

            json.append(String.format(
                "{\"ProductID\":%d,\"ProductName\":\"%s\",\"Category\":\"%s\",\"Price\":%.2f,\"Series\":\"%s\",\"Image\":\"%s\"}",
                productID, productName, category, price, series, image
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    json.append("]");
    out.print(json.toString());
%>