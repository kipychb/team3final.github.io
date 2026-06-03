<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    // 設定編碼防中文亂碼，設定純文字回傳格式
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/plain;charset=UTF-8");

    // 從 Session 內檢驗並獲取會員帳號 mid
    Object midObj = session.getAttribute("mid");
    if (midObj == null) {
        out.print("nologin");
        return;
    }
    int memberID = (int) midObj;

    // 獲取前端發送的參數
    String name = request.getParameter("name");
    String birth = request.getParameter("birth");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    // 檢查參數是否齊全
    if (name == null || birth == null || email == null || phone == null) {
        out.print("missing_parameters");
        return;
    }

    try {
        // 利用 PreparedStatement 防止 SQL 注入，更新會員資料
        String sql = "UPDATE `member` SET `MemberName` = ?, `Birthday` = ?, `Email` = ?, `Phone` = ? WHERE `MemberID` = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, name);
        
        // 若日期欄位為空，則在資料庫內存入 NULL
        if (birth.trim().isEmpty()) {
            pstmt.setNull(2, java.sql.Types.DATE);
        } else {
            pstmt.setString(2, birth);
        }
        
        pstmt.setString(3, email);
        pstmt.setString(4, phone);
        pstmt.setInt(5, memberID);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("success");
        } else {
            out.print("fail");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>