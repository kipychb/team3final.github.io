<%@page contentType="text/html;charset=utf-8" language="java" import="java.sql.*"%>
<%@include file="../../utils/config.jsp" %>
<%
    String varEmail = request.getParameter("email");
    String varPassword = request.getParameter("password");
    
    if(varEmail != null && !varEmail.equals("") && varPassword != null && !varPassword.equals("")){
        
        String sql = "SELECT * FROM `member` WHERE Email = ? AND Password = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, varEmail);
        pstmt.setString(2, varPassword);
        ResultSet rs = pstmt.executeQuery();
        
        if(rs.next()){
            session.setAttribute("email", rs.getString("Email"));
            session.setAttribute("mid", rs.getInt("MemberID"));
            session.setAttribute("Rank", rs.getString("Rank"));
            con.close();
            response.sendRedirect("../index.jsp");
        }
        else{
            con.close();
            response.sendRedirect("index.jsp?is_login=false");
        }
    }
    else {
        response.sendRedirect("index.jsp?is_login=false");
    }
%>