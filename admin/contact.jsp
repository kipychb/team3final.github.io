<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>聯絡留言管理 — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* 留言內容需要保留換行 */
        .msg-contents { white-space: pre-wrap; line-height: 1.7; font-size: 0.88rem; color: #3a3a3a; }
        .col-method    { color: #705844; font-size: 0.85rem; }
        .msg-card td   { vertical-align: top; }
    </style>
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">聯絡我們留言</h1>
        <span class="admin-subtitle">Contact Us</span>
    </div>

    <a class="admin-back-link" href="index.jsp">← 返回後台首頁</a>

    <%
        int total = 0;
        try {
            PreparedStatement psCount = con.prepareStatement("SELECT COUNT(*) FROM `contact_us`");
            ResultSet rsCount = psCount.executeQuery();
            if (rsCount.next()) total = rsCount.getInt(1);
            rsCount.close(); psCount.close();
        } catch (Exception ignore) {}
    %>
    <p style="font-size:0.85rem; color:#A3A69C; margin-bottom:18px;">共 <strong style="color:#705844;"><%= total %></strong> 則留言</p>

    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width:60px;">#</th>
                    <th style="width:140px;">姓名</th>
                    <th style="width:180px;">聯絡方式</th>
                    <th>留言內容</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    if (con == null) {
            %>
                <tr class="table-error"><td colspan="4">❌ 資料庫連線失敗，請檢查 config.jsp</td></tr>
            <%
                    } else {
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT `ContactID`, `Name`, `ContactMethod`, `Contents` FROM `contact_us` ORDER BY `ContactID` DESC"
                        );
                        ResultSet rs = ps.executeQuery();

                        boolean hasRow = false;
                        while (rs.next()) {
                            hasRow = true;
                            String name    = rs.getString("Name");
                            String method  = rs.getString("ContactMethod");
                            String content = rs.getString("Contents");

                            if (name    == null) name    = "（無姓名）";
                            if (method  == null) method  = "（未提供）";
                            if (content == null) content = "";

                            // XSS 防護：跳脫 HTML 特殊字元
                            name    = name   .replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
                            method  = method .replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
                            content = content.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
            %>
                <tr class="msg-card">
                    <td class="col-id"><%= rs.getInt("ContactID") %></td>
                    <td style="font-weight:600;"><%= name %></td>
                    <td class="col-method"><%= method %></td>
                    <td><p class="msg-contents"><%= content %></p></td>
                </tr>
            <%
                        }
                        if (!hasRow) {
            %>
                <tr><td colspan="4" class="admin-empty">目前沒有任何聯絡留言 ✿</td></tr>
            <%
                        }
                        rs.close(); ps.close();
                    }
                } catch (Exception e) {
            %>
                <tr class="table-error"><td colspan="4">錯誤：<%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
