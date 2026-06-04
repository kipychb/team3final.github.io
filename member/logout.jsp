<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 註銷目前的 Session [1]
    session.invalidate();
    
    // 導向首頁
    response.sendRedirect("../index.jsp");
%>