<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="utils/config.jsp" %>
<%!
    private String h(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#x27;");
    }
%>
<%
    String q = request.getParameter("q");
    if (q == null) q = "";
    q = q.trim();

    boolean isTag = q.startsWith("#");
    String searchQ = isTag ? q.substring(1).trim() : q;

    if (searchQ.isEmpty() && !isTag) {
        // 無關鍵字：顯示熱門搜尋 + 隨機推薦商品
        String[] hotKeywords = {"青春", "向日葵", "朋友"};
%>
<li class="suggestion-label">近期熱搜：</li>
<li class="suggestion-hot-wrap">
<%
        for (String kw : hotKeywords) {
%>
    <span class="suggestion-hot" onclick="doSearch('#<%= h(kw) %>')">#<%= h(kw) %></span>
<%
        }
%>
</li>
<li class="suggestion-label">推薦商品：</li>
<%
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT ProductID, ProductName FROM `product` ORDER BY RAND() LIMIT 5");
            while (rs.next()) {
                String pid   = rs.getString("ProductID");
                String pname = rs.getString("ProductName");
%>
<li class="suggestion-product" onclick="location.href='product/index.jsp?id=<%= h(pid) %>'">
    <span class="suggestion-product-name"><%= h(pname) %></span>
</li>
<%
            }
        } catch (Exception e) {
            // 靜默略過
        } finally {
            if (rs != null)   try { rs.close();   } catch (Exception ignore) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
        }

    } else if (!searchQ.isEmpty()) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean found = false;
        try {
            String like = "%" + searchQ + "%";
            if (isTag) {
                // #tag 模式：只搜尋標籤欄位
                ps = con.prepareStatement(
                    "SELECT ProductID, ProductName FROM `product` " +
                    "WHERE Language LIKE ? OR Idea LIKE ? OR Material LIKE ? OR Series LIKE ? LIMIT 20"
                );
                ps.setString(1, like); ps.setString(2, like);
                ps.setString(3, like); ps.setString(4, like);
%>
<li class="suggestion-label">標籤搜尋：<%= h(searchQ) %></li>
<%
            } else {
                // 一般模式：名稱 + 標籤欄位
                ps = con.prepareStatement(
                    "SELECT ProductID, ProductName FROM `product` " +
                    "WHERE ProductName LIKE ? OR Language LIKE ? OR Idea LIKE ? OR Material LIKE ? OR Series LIKE ? LIMIT 20"
                );
                ps.setString(1, like); ps.setString(2, like); ps.setString(3, like);
                ps.setString(4, like); ps.setString(5, like);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                found = true;
                String pid   = rs.getString("ProductID");
                String pname = rs.getString("ProductName");
                if (pname == null) pname = "";
%>
<li class="suggestion-product" onclick="location.href='product/index.jsp?id=<%= h(pid) %>'">
    <span class="suggestion-product-name"><%= h(pname) %></span>
</li>
<%
            }
        } catch (Exception e) {
%>
<li class="suggestion-info">搜尋時發生錯誤，請稍後再試</li>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        }
        if (!found) {
%>
<li class="suggestion-info">找不到符合「<%= h(searchQ) %>」的商品</li>
<%
        }
    }
%>
