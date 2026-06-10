<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*" %>
<%@include file="../utils/config.jsp" %>
<%! 
    // 萬能全自動安全字串處理，確保絕對不會破壞 JSON 結構
    public String cleanForJson(String s) { 
        if (s == null) return ""; 
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n")
                .replace("\t", "\\t"); 
    } 
%>
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

    // 用一個全新的 StringBuilder 把所有輸出包起來，確保「出錯時絕不吐出畸形半截字串」
    StringBuilder jsonResult = new StringBuilder();

    try {
        int targetID = Integer.parseInt(idStr.trim());
        String category = "fresh"; 
        int relativeIndex = 1;

        // 1. 查詢分類
        String catSql = "SELECT `Category` FROM `product` WHERE `ProductID` = ?";
        catPstmt = con.prepareStatement(catSql);
        catPstmt.setInt(1, targetID);
        catRs = catPstmt.executeQuery();
        if (catRs.next()) {
            String tempCat = catRs.getString("Category");
            if(tempCat != null && !tempCat.trim().isEmpty()) {
                category = tempCat.trim();
            }
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
            String productName = cleanForJson(rs.getString("ProductName"));
            double price = rs.getDouble("Price");
            int quantity = rs.getInt("Quantity");
            
            String series = cleanForJson(rs.getString("Series"));
            if(series.isEmpty()) series = "Default";
            
            String size = cleanForJson(rs.getString("Size"));
            String material = cleanForJson(rs.getString("Material"));
            String appreciationPeriod = cleanForJson(rs.getString("AppreciationPeriod"));
            
            String imageRaw = rs.getString("Image");
            String imageJson = (imageRaw != null) ? cleanForJson(imageRaw.trim()) : "";

            // 修正：抽離區域函數呼叫，改用最安全的老派迴圈拼接
            String saveMethodsRaw = rs.getString("SaveMethods");
            StringBuilder sbMethods = new StringBuilder("[");
            if (saveMethodsRaw != null && !saveMethodsRaw.trim().isEmpty() && !saveMethodsRaw.trim().equalsIgnoreCase("null")) {
                String[] methods = saveMethodsRaw.split("、");
                for (int i = 0; i < methods.length; i++) {
                    if(methods[i] != null) {
                        String cleanMethod = methods[i].replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "").replace("\n", "\\n");
                        sbMethods.append("\"").append(cleanMethod).append("\"");
                        if (i < methods.length - 1) sbMethods.append(",");
                    }
                }
            }
            sbMethods.append("]");

            String language = cleanForJson(rs.getString("Language"));
            if(language.isEmpty()) language = "中文";

            String idea = cleanForJson(rs.getString("Idea"));

            // 把所有的 JSON 組裝乾淨地塞進變數，不出錯才一併吐給前端
            jsonResult.append("{")
                      .append("\"ProductID\":").append(targetID).append(",")
                      .append("\"ProductName\":\"").append(productName).append("\",")
                      .append("\"Category\":\"").append(category).append("\",")
                      .append("\"Price\":").append(price).append(",")
                      .append("\"Quantity\":").append(quantity).append(",")
                      .append("\"Series\":\"").append(series).append("\",")
                      .append("\"Size\":\"").append(size).append("\",")
                      .append("\"Material\":\"").append(material).append("\",")
                      .append("\"AppreciationPeriod\":\"").append(appreciationPeriod).append("\",")
                      .append("\"SaveMethods\":").append(sbMethods.toString()).append(",")
                      .append("\"Language\":\"").append(language).append("\",")
                      .append("\"Idea\":\"").append(idea).append("\",")
                      .append("\"relativeIndex\":").append(relativeIndex).append(",")
                      .append("\"Image\":\"").append(imageJson).append("\"")
                      .append("}");
        } else {
            jsonResult.append("{}");
        }
        
        // 成功執行完畢，正式輸出 JSON
        out.print(jsonResult.toString());

    } catch (Exception e) {
        // 全域攔截：即使萬一資料庫讀取斷線或出錯，保證吐出前端看得懂的標準 JSON
        out.print("{\"error\": \"Java Error: " + e.toString().replace("\"", "\\\"") + "\"}");
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e){}
        try { if (pstmt != null) pstmt.close(); } catch(Exception e){}
        try { if (catRs != null) catRs.close(); } catch(Exception e){}
        try { if (catPstmt != null) catPstmt.close(); } catch(Exception e){}
        try { if (rankRs != null) rankRs.close(); } catch(Exception e){}
        try { if (rankPstmt != null) rankPstmt.close(); } catch(Exception e){}
    }
%>