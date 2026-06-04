<%@page contentType="text/plain;charset=utf-8" language="java" %>
<%
    Object midObj = session.getAttribute("mid");
    if (midObj != null) {
        out.print("true");
    } else {
        out.print("false");
    }
%>