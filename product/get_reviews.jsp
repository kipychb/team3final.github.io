<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    String productID = request.getParameter("product_id");

    if (productID == null || productID.trim().isEmpty()) {
        out.print("{\"average\": 0.0, \"count\": 0, \"reviews\": []}");
        return;
    }

    double totalRating = 0;
    int reviewCount = 0;
    StringBuilder reviewsJson = new StringBuilder();

    try {
        // 1. 查詢該商品的所有評價，並 JOIN 會員表取得會員名稱
        String sql = "SELECT g.Rating, g.Contents, g.DateTime, m.MemberName " +
                     "FROM `guestbook` g " +
                     "JOIN `member` m ON g.MemberID = m.MemberID " +
                     "WHERE g.ProductID = ? " +
                     "ORDER BY g.DateTime DESC";
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productID);
        ResultSet rs = pstmt.executeQuery();

        boolean first = true;
        while (rs.next()) {
            double rating = rs.getDouble("Rating");
            String contents = rs.getString("Contents").replace("\\", "\\\\").replace("\"", "\\\"");
            String datetime = rs.getString("DateTime");
            String memberName = rs.getString("MemberName").replace("\\", "\\\\").replace("\"", "\\\"");

            totalRating += rating;
            reviewCount++;

            if (!first) {
                reviewsJson.append(",");
            }
            first = false;

            reviewsJson.append(String.format(
                "{\"name\":\"%s\", \"stars\":%.1f, \"comment\":\"%s\", \"datetime\":\"%s\"}",
                memberName, rating, contents, datetime
            ));
        }

        double average = (reviewCount > 0) ? (totalRating / reviewCount) : 0.0;
        
        // 輸出 JSON 格式
        out.print("{");
        out.print("\"average\":" + String.format("%.1f", average) + ",");
        out.print("\"count\":" + reviewCount + ",");
        out.print("\"reviews\":[" + reviewsJson.toString() + "]");
        out.print("}");

    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"average\": 0.0, \"count\": 0, \"reviews\": [], \"error\":\"" + e.getMessage() + "\"}");
    }
%>