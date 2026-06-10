<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%
    // 檢查是否有經過前一頁 index.jsp 的信箱比對驗證。若無，則禁止直接開啟
    Object resetEmailObj = session.getAttribute("reset_email");
    if (resetEmailObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String resetEmail = (String) resetEmailObj;
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重設密碼 | 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="login-container">
        <div class="login-logo">重設您的密碼</div>
        <p class="login-desc">
            已成功驗證信箱！<br>
            <span class="reset-email"><%=resetEmail%></span><br>
            請在下方輸入您要設定的新密碼。
        </p>
        
        <form action="doReset.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label>設定新密碼</label>
                <input type="password" name="new_password" id="new_password" placeholder="請輸入至少 6 位新密碼" required>
            </div>
            <div class="form-group">
                <label>確認新密碼</label>
                <input type="password" id="confirm_new_password" placeholder="請再次輸入新密碼" required>
            </div>
            <button type="submit" class="login-btn">確認修改密碼</button>
        </form>

        <div class="back-links">
            <a href="../index.jsp">取消並返回登入</a>
        </div>
    </div>

    <script>
        function validateForm() {
            const password = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_new_password').value;

            if (password.length < 6) {
                alert("密碼長度必須至少為 6 個字元！✿");
                return false;
            }

            if (password !== confirmPassword) {
                alert("確認密碼輸入不一致！✿");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>