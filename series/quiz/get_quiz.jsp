<%@page contentType="application/json;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../utils/config.jsp" %>
[
<%
    // 從資料庫取得所有測驗題目
    String sql = "SELECT * FROM `quiz` ORDER BY `QuestionID` ASC";
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
    boolean first = true;
    while(rs.next()) {
        if(!first) {
            out.print(",");
        }
        first = false;
        
        String title = rs.getString("Title").replace("\\", "\\\\").replace("\"", "\\\"");
        String optA = rs.getString("OptA").replace("\\", "\\\\").replace("\"", "\\\"");
        String optB = rs.getString("OptB").replace("\\", "\\\\").replace("\"", "\\\"");
        String optC = rs.getString("OptC").replace("\\", "\\\\").replace("\"", "\\\"");
        String optD = rs.getString("OptD").replace("\\", "\\\\").replace("\"", "\\\"");
        String optE = rs.getString("OptE").replace("\\", "\\\\").replace("\"", "\\\"");
%>
    {
        "title": "<%=title%>",
        "options": [
            { "text": "<%=optA%>", "type": "A" },
            { "text": "<%=optB%>", "type": "B" },
            { "text": "<%=optC%>", "type": "C" },
            { "text": "<%=optD%>", "type": "D" },
            { "text": "<%=optE%>", "type": "E" }
        ]
    }
<%
    }
%>
]