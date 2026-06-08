<%@ page contentType="application/json;charset=utf-8" language="java" import="java.sql.*" %>
    <%@ include file="../utils/config.jsp" %>
        <% request.setCharacterEncoding("UTF-8"); response.setContentType("application/json;charset=UTF-8"); Object
            midObj=session.getAttribute("mid"); if (midObj==null) { out.print("[]"); return; } int
            memberID=Integer.parseInt(midObj.toString()); try { String
            sql="SELECT id, coupon_amount, claimed_at, status " + "FROM member_coupons "
            + "WHERE member_id = ? AND status = '未使用' " + "ORDER BY claimed_at DESC" ; PreparedStatement
            pstmt=con.prepareStatement(sql); pstmt.setInt(1, memberID); ResultSet rs=pstmt.executeQuery(); StringBuilder
            json=new StringBuilder(); json.append("["); boolean first=true; while (rs.next()) { if (!first)
            json.append(","); first=false; json.append("{"); json.append("\"id\":").append(rs.getInt("id")).append(",");
            json.append("\"amount\":").append(rs.getInt("coupon_amount")).append(",");
            json.append("\"status\":\"").append(rs.getString("status")).append("\""); json.append("}"); }
            json.append("]"); out.print(json.toString()); rs.close(); pstmt.close(); } catch (Exception e) {
            out.print("[]"); } %>