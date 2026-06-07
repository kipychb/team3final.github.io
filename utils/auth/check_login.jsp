<%
    try {
        Object midObj = session.getAttribute("mid");
    }
    
    if (midObj == null) {
        response.sendRedirect("member/login/index.jsp");
        return;
    }
    
    try {
        int MemberID = (int) midObj;
    }
%>