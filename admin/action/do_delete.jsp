<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
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

            String sql = "DELETE FROM product WHERE ProductID = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(id.trim()));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            out.println("<script>alert('✅ 商品已成功刪除！'); window.location.href='../index.jsp';</script>");
        } catch(Exception e) {
            out.println("<script>alert('刪除失敗！該商品可能已被加入購物車或訂單中，无法删除。'); history.back();</script>");
        }
    } else {
        out.println("<script>alert('未指定商品！'); history.back();</script>");
    }
%>