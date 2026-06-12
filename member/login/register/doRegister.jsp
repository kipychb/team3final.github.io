<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../../../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String birthday = request.getParameter("birthday");

    // 1. 基本防呆驗證
    if (username == null ||
    email == null ||
    password == null ||
    birthday == null ||

    username.trim().isEmpty() ||
    email.trim().isEmpty() ||
    password.trim().isEmpty() ||
    birthday.trim().isEmpty())

    try {
        // 2. 檢查電子郵件是否重複註冊
        String checkSql = "SELECT COUNT(*) FROM `member` WHERE `Email` = ?";
        PreparedStatement checkPstmt = con.prepareStatement(checkSql);
        checkPstmt.setString(1, email);
        ResultSet checkRs = checkPstmt.executeQuery();
        checkRs.next();
        int count = checkRs.getInt(1);
        checkRs.close();
        checkPstmt.close();

        if (count > 0) {
            response.sendRedirect("index.jsp?error=exists");
            return;
        }

        // 3. 寫入資料庫：Birthday 給予預設值 '2025-01-01'，Rank 給予預設值 '可悲會員' 
       String insertSql =
        "INSERT INTO member " +
        "(MemberName, Email, Password, Phone, Address, Rank, Birthday) " +
        "VALUES (?, ?, ?, ?, ?, '可悲會員', ?)";
        PreparedStatement insertPstmt = con.prepareStatement(insertSql);
        insertPstmt.setString(1, username);
        insertPstmt.setString(2, email);
        insertPstmt.setString(3, password);
        insertPstmt.setString(4, (phone == null || phone.trim().isEmpty()) ? null : phone);
        insertPstmt.setString(5, (address == null || address.trim().isEmpty()) ? null : address);
        insertPstmt.setString(6, birthday);

        int rows = insertPstmt.executeUpdate();
        insertPstmt.close();

        if (rows > 0) {
            // 註冊成功，彈出歡迎視窗並跳轉回登入頁面
%>
            <script>
                alert("註冊成功！歡迎加入花予祝願所 ✿");
                window.location.href = "../index.jsp";
            </script>
<%
        } else {
            response.sendRedirect("index.jsp?error=fail");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp?error=fail");
    }
%>