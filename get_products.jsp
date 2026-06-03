<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="utils/config.jsp" %>
[
<%
    // 從資料庫取得所有花卉商品，並依 ProductID 排序
    String sql = "SELECT * FROM `product` ORDER BY `ProductID` ASC";
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
    boolean first = true;
    while(rs.next()) {
        if(!first) {
            out.print(",");
        }
        first = false;
        
        int productID = rs.getInt("ProductID");
        // 進行 JSON 字元跳脫防範格式破壞
        String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
        String category = rs.getString("Category");
        double price = rs.getDouble("Price");
        int quantity = rs.getInt("Quantity");
        String series = rs.getString("Series").replace("\\", "\\\\").replace("\"", "\\\"");
%>
    {
        "ProductID": <%=productID%>,
        "ProductName": "<%=productName%>",
        "Category": "<%=category%>",
        "Price": <%=price%>,
        "Quantity": <%=quantity%>,
        "Series": "<%=series%>"
    }
<%
    }
%>
]