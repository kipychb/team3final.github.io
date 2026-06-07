<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 讀取前端表單傳過來的參數
    String name = request.getParameter("name");
    String contactMethod = request.getParameter("contact_method");
    String contents = request.getParameter("contents");

    // 2. 進行基本防呆檢查
    if (name != null && contactMethod != null && contents != null &&
        !name.trim().isEmpty() && !contactMethod.trim().isEmpty() && !contents.trim().isEmpty()) {
        
        try {
            // 3. 執行 SQL 插入動作，寫入到 contact_us 資料表中
            String sql = "INSERT INTO `contact_us` (`Name`, `ContactMethod`, `Contents`) VALUES (?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, contactMethod);
            pstmt.setString(3, contents);
            
            int rows = pstmt.executeUpdate();
            pstmt.close();
            
            if (rows > 0) {
%>
                <script>
                    alert("訊息已成功送出！感謝您的聯絡，我們將盡快回覆您 ✿");
                    window.location.href = "index.jsp"; // 成功後導回首頁
                </script>
<%
            } else {
%>
                <script>
                    alert("發送失敗，請稍後再試！ ✿");
                    history.back();
                </script>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
%>
            <script>
                alert("伺服器錯誤：<%= e.getMessage().replace("\"", "\\\"") %>");
                history.back();
            </script>
<%
        }
    } else {
%>
        <script>
            alert("請填寫所有必要欄位！ ✿");
            history.back();
        </script>
<%
    }
%>