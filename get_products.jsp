

<%@ page contentType="application/json;charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="utils/config.jsp" %>

<%! 
    public String esc(String s) { 
        if (s == null) return ""; 
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "").replace("\n", "\\n"); 
    } 
%>

<% 
    String sql = "SELECT ProductID, ProductName, Category, Price, Quantity, Series, Language, Idea, Material, Image FROM product ORDER BY ProductID ASC"; 
    
    PreparedStatement pstmt = con.prepareStatement(sql); 
    ResultSet rs = pstmt.executeQuery(); 
    
    out.print("[");
    boolean first = true; 
    
    while (rs.next()) { 
        if (!first) { 
            out.print(","); 
        } 
        first = false; 
        
        out.print("{");
        out.print("\"ProductID\":" + rs.getInt("ProductID") + ","); 
        out.print("\"ProductName\":\"" + esc(rs.getString("ProductName")) + "\","); 
        out.print("\"Category\":\"" + esc(rs.getString("Category")) + "\","); 
        out.print("\"Price\":" + rs.getDouble("Price") + ","); 
        out.print("\"Quantity\":" + rs.getInt("Quantity") + ","); 
        out.print("\"Series\":\"" + esc(rs.getString("Series")) + "\","); 
        out.print("\"Language\":\"" + esc(rs.getString("Language")) + "\","); 
        out.print("\"Idea\":\"" + esc(rs.getString("Idea")) + "\","); 
        out.print("\"Material\":\"" + esc(rs.getString("Material")) + "\",");
        out.print("\"Image\":\"" + esc(rs.getString("Image")) + "\""); 
        out.print("}"); 
    } 
    
    out.print("]"); 
    rs.close(); 
    pstmt.close(); 
%>