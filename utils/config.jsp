<%@ page import="java.sql.*" %>
<%
    // 統一資料庫連線設定（已兼容你原本的設定）
    Connection con = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");   
        String url = "jdbc:mysql://localhost:3306/flower?useUnicode=true&characterEncoding=utf-8&serverTimezone=UTC";
        String user = "root";
        String pass = "1234";   // 如果你的密碼是空的就保持這樣；如果是1234請改成 "1234"
        
        con = DriverManager.getConnection(url, user, pass);
        // 把 con 放到 request，讓其他頁面可以直接使用
        request.setAttribute("con", con);
    } catch(Exception e) {
        out.println("資料庫連線錯誤: " + e.getMessage());
        e.printStackTrace();
    }
%>