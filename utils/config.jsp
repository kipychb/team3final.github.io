<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con=DriverManager.getConnection("jdbc:mysql://localhost/?serverTimezone=UTC","root","1234");
    con.createStatement().execute("USE `flower`");
%>