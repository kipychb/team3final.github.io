<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../../utils/config.jsp" %>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>會員登入 | 花予祝願所</title>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="style.css">
    </head>

    <body>

        <a href="../../index.html" class="back-home">
            <i class="fa-solid fa-arrow-left"></i> 返回首頁
        </a>

        <div class="login-container">
            <div class="login-logo">花予祝願所</div>

            <form action="checkLogin.jsp" method="post" class="login-form">
                <div class="form-group">
                    <label>帳號 / 電子郵件</label>
                    <input type="email" name="email" placeholder="請輸入帳號" required>
                </div>
                <div class="form-group">
                    <label>密碼</label>
                    <input type="password" name="password" placeholder="請輸入密碼" required>
                </div>

                <%
                    String is_login = request.getParameter("is_login");
                    if ("false".equals(is_login)){
                        out.print("<div class='login-errmsg'>密碼帳號不符！！</div>");
                    }
                %>

                <input type="submit" value="登入" class="login-btn">
            </form>

            <div class="extra-links">
                <a href="forgot/index.html">忘記密碼？</a>
                <span>|</span>
                <a href="register/index.html">註冊會員</a>
            </div>
        </div>

    </body>

</html>