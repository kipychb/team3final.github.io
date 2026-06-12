<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員註冊 | 花予祝願所</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+TC:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    
    <a href="../index.jsp" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> 返回登入
    </a>

<div class="login-container">
        <div class="login-logo">加入花予</div>
        <p class="login-desc">成為會員，收藏您的命定花語</p>
        
        <form action="doRegister.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                
                <label>使用者名稱 <span class="required">*</span></label>
                <input type="text" name="username" id="username" placeholder="例如：花小編" required>
            </div>
            <div class="form-group">
                <label>電子郵件 <span class="required">*</span></label>
                <input type="email" name="email" id="email" placeholder="123456@mail.com" required>
            </div>
            <div class="form-group">
                <label>設定密碼 <span class="required">*</span></label>
                <input type="password" name="password" id="password" placeholder="請輸入至少 6 位密碼" required>
            </div>
            <div class="form-group">
                <label>確認密碼 <span class="required">*</span></label>
                <input type="password" id="confirm_password" placeholder="請再次輸入密碼" required>
            </div>
            <div class="form-group">
                <label>生日 <span class="required">*</span></label>
                <input type="date" name="birthday" required>
            </div>
            
            <!-- 選填欄位 -->
            <div class="form-group">
                <label>手機號碼 (選填)</label>
                <input type="tel" name="phone" placeholder="例如：0912345678">
            </div>
            <div class="form-group">
                <label>送貨地址 (選填)</label>
                <input type="text" name="address" placeholder="例如：桃園市中壢區...">
            </div>

            <%
                String error = request.getParameter("error");
                if ("exists".equals(error)) {
                    out.print("<div class='error-msg'>該電子郵件已被註冊過！</div>");
                } else if ("fail".equals(error)) {
                    out.print("<div class='error-msg'>註冊失敗，請檢查資料格式！</div>");
                }
            %>
            
            <button type="submit" class="login-btn">立即註冊</button>
        </form>

        <div class="back-links">
            <a href="../index.jsp">已有帳號？回登入頁面</a>
        </div>
    </div>

    <script>
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm_password').value;

            if (password.length < 6) {
                alert("密碼長度必須至少為 6 個字元！✿");
                return false;
            }

            if (password !== confirmPassword) {
                alert("兩次輸入的密碼不一致，請重新檢查！✿");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>