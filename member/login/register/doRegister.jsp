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

if (username == null || email == null || password == null || birthday == null ||
    username.trim().isEmpty() || email.trim().isEmpty() ||
    password.trim().isEmpty() || birthday.trim().isEmpty()) {

    response.sendRedirect("index.jsp?error=missing");
    return;
}

try {
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
%>
<script>
    alert("註冊成功！歡迎加入花予祝願所 ✿");
    window.location.href = "../index.jsp";
</script>
<%
        return;
    } else {
        response.sendRedirect("index.jsp?error=fail");
        return;
    }

} catch (Exception e) {
    String msg = e.getMessage();
    if (msg == null) msg = "unknown error";
%>
<h3>註冊失敗</h3>
<p>錯誤原因：<%= msg %></p>
<a href="index.jsp">回註冊頁</a>
<%
}
%>