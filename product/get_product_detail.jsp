<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
<%
    // 設定編碼防亂碼
    request.setCharacterEncoding("UTF-8");

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.trim().isEmpty()) {
        out.print("{}");
        return;
    }

    int targetID = Integer.parseInt(idStr);

    // 1. 為了計算圖片路徑，我們需要知道這個商品在其類別（fresh / dried）中按 ProductID 排序是第幾個
    String category = "";
    int relativeIndex = 1;

    // 先查詢目標商品的分類
    String catSql = "SELECT `Category` FROM `product` WHERE `ProductID` = ?";
    PreparedStatement catPstmt = con.prepareStatement(catSql);
    catPstmt.setInt(1, targetID);
    ResultSet catRs = catPstmt.executeQuery();
    if (catRs.next()) {
        category = catRs.getString("Category");
    } else {
        out.print("{}");
        return;
    }

    // 計算在該分類中的相對順序 (第幾筆)
    String rankSql = "SELECT COUNT(*) AS `rank` FROM `product` WHERE `Category` = ? AND `ProductID` <= ?";
    PreparedStatement rankPstmt = con.prepareStatement(rankSql);
    rankPstmt.setString(1, category);
    rankPstmt.setInt(2, targetID);
    ResultSet rankRs = rankPstmt.executeQuery();
    if (rankRs.next()) {
        relativeIndex = rankRs.getInt("rank");
    }

    // 2. 獲取該商品的詳細資料
    String sql = "SELECT * FROM `product` WHERE `ProductID` = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, targetID);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        String productName = rs.getString("ProductName").replace("\\", "\\\\").replace("\"", "\\\"");
        double price = rs.getDouble("Price");
        int quantity = rs.getInt("Quantity");
        String series = rs.getString("Series").replace("\\", "\\\\").replace("\"", "\\\"");
        String size = rs.getString("Size").replace("\\", "\\\\").replace("\"", "\\\"");
        String material = rs.getString("Material").replace("\\", "\\\\").replace("\"", "\\\"");
        String appreciationPeriod = rs.getString("AppreciationPeriod").replace("\\", "\\\\").replace("\"", "\\\"");
        
        // 處理、切割儲存的保存方法 SaveMethods
        String saveMethodsRaw = rs.getString("SaveMethods");
        String saveMethodsJson = "[]";
        if (saveMethodsRaw != null && !saveMethodsRaw.trim().isEmpty()) {
            String[] methods = saveMethodsRaw.split("、");
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < methods.length; i++) {
                sb.append("\"").append(methods[i].replace("\\", "\\\\").replace("\"", "\\\"")).append("\"");
                if (i < methods.length - 1) {
                    sb.append(",");
                }
            }
            sb.append("]");
            saveMethodsJson = sb.toString();
        }

        String language = rs.getString("Language").replace("\\", "\\\\").replace("\"", "\\\"");
        String idea = rs.getString("Idea").replace("\\", "\\\\").replace("\"", "\\\"");
%>
{
    "ProductID": <%=targetID%>,
    "ProductName": "<%=productName%>",
    "Category": "<%=category%>",
    "Price": <%=price%>,
    "Quantity": <%=quantity%>,
    "Series": "<%=series%>",
    "Size": "<%=size%>",
    "Material": "<%=material%>",
    "AppreciationPeriod": "<%=appreciationPeriod%>",
    "SaveMethods": <%=saveMethodsJson%>,
    "Language": "<%=language%>",
    "Idea": "<%=idea%>",
    "relativeIndex": <%=relativeIndex%>
}
<%
    } else {
        out.print("{}");
    }
%>