<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../utils/config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=utf-8");

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.trim().isEmpty()) {
        out.print("{}");
        return;
    }

    PreparedStatement catPstmt = null;
    ResultSet catRs = null;
    PreparedStatement rankPstmt = null;
    ResultSet rankRs = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        int targetID = Integer.parseInt(idStr.trim());
        String category = "";
        int relativeIndex = 1;

        // 1. 查詢分類
        String catSql = "SELECT `Category` FROM `product` WHERE `ProductID` = ?";
        catPstmt = con.prepareStatement(catSql);
        catPstmt.setInt(1, targetID);
        catRs = catPstmt.executeQuery();
        if (catRs.next()) {
            category = catRs.getString("Category");
        } else {
            out.print("{}");
            return;
        }

        // 2. 計算流水號
        String rankSql = "SELECT COUNT(*) AS `rank` FROM `product` WHERE `Category` = ? AND `ProductID` <= ?";
        rankPstmt = con.prepareStatement(rankSql);
        rankPstmt.setString(1, category);
        rankPstmt.setInt(2, targetID);
        rankRs = rankPstmt.executeQuery();
        if (rankRs.next()) {
            relativeIndex = rankRs.getInt("rank");
        }

        // 3. 撈取詳細資料
        String sql = "SELECT * FROM `product` WHERE `ProductID` = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, targetID);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String productName = rs.getString("ProductName");
            if(productName == null) productName = "";
            productName = productName.replace("\\", "\\\\").replace("\"", "\\\"");

            double price = rs.getDouble("Price");
            int quantity = rs.getInt("Quantity");
            
            String series = rs.getString("Series");
            if(series == null) series = "";
            series = series.replace("\\", "\\\\").replace("\"", "\\\"");

            String size = rs.getString("Size");
            if(size == null) size = "";
            size = size.replace("\\", "\\\\").replace("\"", "\\\"");

            String material = rs.getString("Material");
            if(material == null) material = "";
            material = material.replace("\\", "\\\\").replace("\"", "\\\"");

            String appreciationPeriod = rs.getString("AppreciationPeriod");
            if(appreciationPeriod == null) appreciationPeriod = "";
            appreciationPeriod = appreciationPeriod.replace("\\", "\\\\").replace("\"", "\\\"");
            
            String imageRaw = rs.getString("Image");
            String imageJson = (imageRaw != null) ? imageRaw.trim().replace("\\", "\\\\").replace("\"", "\\\"") : "";

            String saveMethodsRaw = rs.getString("SaveMethods");
            String saveMethodsJson = "[]";
            if (saveMethodsRaw != null && !saveMethodsRaw.trim().isEmpty()) {
                String[] methods = saveMethodsRaw.split("、");
                StringBuilder sb = new StringBuilder("[");
                for (int i = 0; i < methods.length; i++) {
                    sb.append("\"").append(methods[i].replace("\\", "\\\\").replace("\"", "\\\"")).append("\"");
                    if (i < methods.length - 1) sb.append(",");
                }
                sb.append("]");
                saveMethodsJson = sb.toString();
            }

            String language = rs.getString("Language");
            if(language == null) language = "";
            language = language.replace("\\", "\\\\").replace("\"", "\\\"");

            String idea = rs.getString("Idea");
            if(idea == null) idea = "";
            idea = idea.replace("\\", "\\\\").replace("\"", "\\\"");
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
    "relativeIndex": <%=relativeIndex%>,
    "Image": "<%=imageJson%>"
}
<%
        } else {
            out.print("{}");
        }
    } catch (Exception e) {
        // 如果真的出錯，吐出 JSON 格式的錯誤訊息，絕對不吐 DOCTYPE HTML！
        out.print("{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e){}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if (catRs != null) try { catRs.close(); } catch(Exception e){}
        if (catPstmt != null) try { catPstmt.close(); } catch(Exception e){}
        if (rankRs != null) try { rankRs.close(); } catch(Exception e){}
        if (rankPstmt != null) try { rankPstmt.close(); } catch(Exception e){}
    }
%>