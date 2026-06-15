<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ include file="../../utils/config.jsp" %>

<%
    // 同時支援 id 和 ProductID 兩種參數
    String id = request.getParameter("ProductID");
    if (id == null || id.trim().isEmpty()) {
        id = request.getParameter("id");   // 兼容列表傳來的參數
    }

    if (id != null && !id.trim().isEmpty()) {
        try {
            if (con == null) {
                out.println("<script>alert('資料庫連線失敗！'); history.back();</script>");
                return;
            }

            int productId = Integer.parseInt(id.trim());

            // 先查出該商品的圖片檔名，待刪除成功後再清掉對應的圖片檔
            String imageFileName = null;
            String selectSql = "SELECT Image FROM product WHERE ProductID = ?";
            PreparedStatement selectStmt = con.prepareStatement(selectSql);
            selectStmt.setInt(1, productId);
            ResultSet rs = selectStmt.executeQuery();
            if (rs.next()) {
                imageFileName = rs.getString("Image");
            }
            rs.close();
            selectStmt.close();

            String sql = "DELETE FROM product WHERE ProductID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, productId);

            pstmt.executeUpdate();
            pstmt.close();

            // 刪除成功後，移除 image/flower/ 內對應的圖片檔（保留共用的預設圖 default.jpg）
            if (imageFileName != null && !imageFileName.trim().isEmpty()
                    && !imageFileName.trim().equalsIgnoreCase("default.jpg")) {
                String imagePath = request.getServletContext().getRealPath("image/flower")
                        + File.separator + imageFileName.trim();
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }

            out.println("<script>alert('✅ 商品已成功刪除！'); window.location.href='../index.jsp';</script>");
        } catch(Exception e) {
            out.println("<script>alert('刪除失敗！該商品可能已被加入購物車或訂單中，无法删除。'); history.back();</script>");
        }
    } else {
        out.println("<script>alert('未指定商品！'); history.back();</script>");
    }
%>