<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String q = request.getParameter("q");
    if (q == null) q = "";
    q = q.trim();

    if (q.isEmpty()) {
        String[] hotKeywords = {"青春", "向日葵", "朋友"};
%>
<li class="suggestion-label" style="font-weight: bold;">近期熱搜：</li>
<%
        for (String kw : hotKeywords) {
%>
<li class="suggestion-hot" onclick="
    document.getElementById('searchInput').value='<%= kw %>';
    document.getElementById('searchInput').dispatchEvent(new Event('input'));
"><%= kw %></li>
<%
        }
%>
<li class="suggestion-label" style="margin-top:20px; font-weight: bold;">推薦商品：</li>
<%
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT ProductID, ProductName FROM `product` ORDER BY RAND() LIMIT 5");

            while (rs.next()) {
                String pid = rs.getString("ProductID");
                String pname = rs.getString("ProductName");
                if (pname == null) pname = "";
%>
<li onclick="location.href='product/index.jsp?id=<%= pid %>'"><%= pname %></li>
<%
            }
        } catch (Exception e) {
%>
<li style="cursor:default; padding:10px;">推薦商品載入失敗，請稍後再試</li>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
        }

    } else {
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean found = false;

        try {
            String like = "%" + q + "%";

            ps = con.prepareStatement(
                "SELECT ProductID, ProductName FROM `product` " +
                "WHERE ProductName LIKE ? " +
                "OR Language LIKE ? " +
                "OR Idea LIKE ? " +
                "OR Material LIKE ? " +
                "OR Series LIKE ? " +
                "ORDER BY ProductID ASC"
            );

            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);

            rs = ps.executeQuery();

            while (rs.next()) {
                found = true;
                String pid = rs.getString("ProductID");
                String pname = rs.getString("ProductName");
                if (pname == null) pname = "";
%>
<li onclick="location.href='product/index.jsp?id=<%= pid %>'"><%= pname %></li>
<%
            }

        } catch (Exception e) {
%>
<li style="cursor:default; padding:10px;">搜尋時發生錯誤，請稍後再試</li>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        }

        if (!found) {
%>
<li style="cursor:default; padding:10px;">找不到符合的商品</li>
<%
        }
    }
%>
