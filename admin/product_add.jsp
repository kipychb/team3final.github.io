<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ include file="../utils/config.jsp" %>
<%
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>上架新產品 — 花予祝願所</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="admin-wrapper">

    <div class="admin-header">
        <h1 class="admin-title">上架新產品</h1>
    </div>

    <a class="admin-back-link" href="index.jsp">← 返回商品列表</a>

    <div class="admin-form-card">
        <form class="admin-form" action="action/do_add.jsp" method="post" enctype="multipart/form-data">

            <div class="form-row">
                <label for="ProductName">產品名稱</label>
                <input type="text" id="ProductName" name="ProductName" required placeholder="請輸入產品名稱">
            </div>

            <div class="form-row">
                <label for="Category">分類</label>
                <input type="text" id="Category" name="Category" value="fresh" required>
                <span class="form-hint">例如：fresh、dried、bouquet</span>
            </div>

            <div class="form-row">
                <label for="Price">價格（NT$）</label>
                <input type="number" id="Price" name="Price" required placeholder="例如：1200">
            </div>

            <div class="form-row">
                <label for="Description">商品描述</label>
                <textarea id="Description" name="Description" rows="5" placeholder="請輸入商品描述..."></textarea>
            </div>

            <div class="form-row">
                <label for="Image">商品圖片（本機上傳）</label>
                <input type="file" id="Image" name="Image" accept="image/*" required>
                <span class="form-hint">支援 JPG、PNG 格式</span>
            </div>

            <div class="form-footer">
                <button type="submit" class="admin-btn btn-primary">✔ 確認上架</button>
                <a href="index.jsp" class="admin-btn btn-ghost">取消</a>
            </div>
        </form>
    </div>

</div>
</body>
</html>
