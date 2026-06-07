<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../../utils/config.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String productName = request.getParameter("ProductName");
    String category = request.getParameter("Category");
    String priceStr = request.getParameter("Price");
    String description = request.getParameter("Description");
    String imageUrl = request.getParameter("Image");

    if (productName == null || productName.trim().isEmpty() || 
        priceStr == null || priceStr.trim().isEmpty()) {
        out.println("<script>alert('請至少填寫商品名稱和價格！'); history.back();</script>");
        return;
    }

    try {
        if (con == null) {
            out.println("<script>alert('資料庫連線失敗！'); history.back();</script>");
            return;
        }

        String sql = "INSERT INTO product (ProductName, Category, Price, Quantity, Series, Size, Material, AppreciationPeriod, SaveMethods, Language, Idea, Image) " +
                     "VALUES (?, ?, ?, 99, 'For Lover', '約 28x24 公分', '玫瑰、尤加利葉', '鮮花保存約5~7天', '避免陽光直射、避免潮濕環境', '中文', ?, ?)";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productName.trim());
        pstmt.setString(2, category != null ? category.trim() : "fresh");
        pstmt.setInt(3, Integer.parseInt(priceStr.trim()));
        pstmt.setString(4, description != null ? description.trim() : "");
        pstmt.setString(5, imageUrl != null ? imageUrl.trim() : null);  // 存入圖片網址

        pstmt.executeUpdate();
        pstmt.close();

        out.println("<script>alert('✅ 產品上架成功！'); window.location.href='../index.jsp';</script>");

    } catch(Exception e) {
        out.println("<script>alert('上架失敗: " + e.getMessage().replace("'", "\\'") + "'); history.back();</script>");
    }
%>