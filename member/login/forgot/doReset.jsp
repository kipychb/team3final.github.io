<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../../../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 安全檢索驗證狀態
    Object resetEmailObj = session.getAttribute("reset_email");
    if (resetEmailObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String resetEmail = (String) resetEmailObj;

    String newPassword = request.getParameter("new_password");

    if (newPassword == null || newPassword.trim().length() < 6) {
%>
        <script>
            alert("新密碼輸入不合法！");
            window.location.href = "reset.jsp";
        </script>
<%
        return;
    }

    try {
        // 2. 將新密碼寫入該使用者的資料庫紀錄
        String sql = "UPDATE `member` SET `Password` = ? WHERE `Email` = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, newPassword);
        pstmt.setString(2, resetEmail);
        int rows = pstmt.executeUpdate();
        pstmt.close();

        // 3. 變更完畢後，清空驗證的臨時 session 資料，確保安全性
        session.removeAttribute("reset_email");

        if (rows > 0) {
%>
            <script>
                alert("密碼已修改成功！歡迎使用新密碼重新登入 ✿");
                window.location.href = "../index.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("密碼更新失敗，請重新嘗試。");
                window.location.href = "index.jsp";
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("資料庫更新異常，請稍後再試。");
            window.location.href = "index.jsp";
        </script>
<%
    }
%>