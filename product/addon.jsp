<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@include file="../utils/config.jsp" %>
<%
    String productIdStr = request.getParameter("id");
    int currentId = 0;
    try { currentId = Integer.parseInt(productIdStr); } catch (Exception ignore) {}

    // 取得當前商品的 Series
    String currentSeries = null;
    try {
        PreparedStatement ps = con.prepareStatement("SELECT `Series` FROM `product` WHERE `ProductID` = ?");
        ps.setInt(1, currentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) currentSeries = rs.getString("Series");
        rs.close(); ps.close();
    } catch (Exception ignore) {}

    // 同系列商品（排除自己），隨機取 4 筆
    List<Map<String,Object>> items = new ArrayList<>();
    if (currentSeries != null) {
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT `ProductID`, `ProductName`, `Price`, `Image` FROM `product` " +
                "WHERE `Series` = ? AND `ProductID` <> ? ORDER BY RAND() LIMIT 4"
            );
            ps.setString(1, currentSeries);
            ps.setInt(2, currentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id",    rs.getInt("ProductID"));
                m.put("name",  rs.getString("ProductName"));
                m.put("price", rs.getInt("Price"));
                m.put("image", rs.getString("Image"));
                items.add(m);
            }
            rs.close(); ps.close();
        } catch (Exception ignore) {}
    }

    // 同系列不足 4 筆時，隨機補其他商品
    if (items.size() < 4) {
        int need = 4 - items.size();
        // 排除已選 ID 與自己
        StringBuilder excludeIds = new StringBuilder(String.valueOf(currentId));
        for (Map<String,Object> m : items) excludeIds.append(",").append(m.get("id"));
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT `ProductID`, `ProductName`, `Price`, `Image` FROM `product` " +
                "WHERE `ProductID` NOT IN (" + excludeIds + ") ORDER BY RAND() LIMIT " + need
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id",    rs.getInt("ProductID"));
                m.put("name",  rs.getString("ProductName"));
                m.put("price", rs.getInt("Price"));
                m.put("image", rs.getString("Image"));
                items.add(m);
            }
            rs.close(); ps.close();
        } catch (Exception ignore) {}
    }

    for (Map<String,Object> item : items) {
        int    pid   = (int) item.get("id");
        String pname = (String) item.get("name");
        int    price = (int) item.get("price");
        String img   = (String) item.get("image");

        // 圖片路徑邏輯：-1.jpg 格式取 -2.jpg；其他直接使用
        String imgPath;
        if (img != null && !img.trim().isEmpty() && img.trim().matches("\\d+-1\\.jpg")) {
            imgPath = "../image/flower/" + img.trim().replace("-1.jpg", "-2.jpg");
        } else if (img != null && !img.trim().isEmpty()) {
            imgPath = "../image/flower/" + img.trim();
        } else {
            imgPath = "../image/default.jpg";
        }

        String priceStr = String.format("%,d", price);
%>
<div class="item">
    <a class="img border-box" href="index.jsp?id=<%= pid %>">
        <img src="<%= imgPath %>" alt="<%= pname %>" onerror="this.onerror=null; this.src='../image/default.jpg';">
    </a>
    <div class="info-row">
        <div class="text-group">
            <span class="name"><%= pname %></span>
            <span class="price">NT$ <%= priceStr %></span>
        </div>
        <button class="action-btn-circle heart-btn" data-id="<%= pid %>">
            <i class="fa-regular fa-heart"></i>
        </button>
        <button class="add-btn-circle" onclick="handleAddToCart(event, <%= pid %>)">
            <i class="fa-solid fa-plus"></i>
        </button>
    </div>
</div>
<%
    }
    if (items.isEmpty()) {
%>
<p style="text-align:center; padding:20px; color:#999;">目前沒有類似商品 ✿</p>
<%
    }
%>
