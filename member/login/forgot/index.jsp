<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../../../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    String errorMsg = "";

    // 當使用者提交表單時
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        if (email != null && !email.trim().isEmpty()) {
            try {
                // 檢查信箱是否存在於 member 資料表
                String sql = "SELECT `MemberID` FROM `member` WHERE `Email` = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, email);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    // 信箱存在，驗證成功。將信箱暫存入 session 中以驗證下一步
                    session.setAttribute("reset_email", email);
                    rs.close();
                    pstmt.close();
                    response.sendRedirect("reset.jsp");
                    return;
                } else {
                    errorMsg = "找不到此電子郵件註冊的會員紀錄！✿";
                }
                rs.close();
                pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
                errorMsg = "系統異常，請稍後再試。";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>忘記密碼 | 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <a href="../index.jsp" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> 返回登入
    </a>

    <div class="login-container">
        <div class="login-logo">找回密碼</div>
        <p style="margin-bottom: 25px; width: 85%; margin: 0 auto 25px; font-size: 14px; line-height: 1.5; color: #c9ad96;">請輸入您的電子郵件，我們將直接在網頁上為您進行安全重設。</p>
        
        <form action="index.jsp" method="post">
            <div class="form-group">
                <label>註冊信箱</label>
                <input type="email" name="email" placeholder="example@mail.com" required>
            </div>

            <% if (!errorMsg.isEmpty()) { %>
                <div style="color: #d87f7f; margin-bottom: 15px; font-size: 0.85rem;"><%=errorMsg%></div>
            <% } %>

            <button type="submit" class="login-btn">下一步驗證</button>
        </form>

        <div class="back-links" style="margin-top: 20px;">
            <a href="../index.jsp">返回登入頁面</a>
        </div>
    </div>
    
</body>
</html>