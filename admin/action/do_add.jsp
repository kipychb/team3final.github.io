<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*,java.io.*,jakarta.servlet.http.*,java.util.UUID" %>
<%@ include file="../../utils/config.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 權限檢查
    if (!"管理員".equals(session.getAttribute("Rank")) && !"Admin".equals(session.getAttribute("Rank"))) {
        out.println("<script>alert('權限不足！'); window.location.href='../../index.jsp';</script>");
        return;
    }

    String productName = null;
    String category = null;
    String priceStr = null;
    String description = null;
    String savedFileName = "default.jpg"; // 預設圖檔名

    try {
        // 🛠️ 在 multipart/form-data 模式下，文字欄位需要從 Part 裡面手動提取
        Part namePart = request.getPart("ProductName");
        if (namePart != null) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(namePart.getInputStream(), "UTF-8"));
            productName = reader.readLine();
        }

        Part catPart = request.getPart("Category");
        if (catPart != null) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(catPart.getInputStream(), "UTF-8"));
            category = reader.readLine();
        }

        Part pricePart = request.getPart("Price");
        if (pricePart != null) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(pricePart.getInputStream(), "UTF-8"));
            priceStr = reader.readLine();
        }

        Part descPart = request.getPart("Description");
        if (descPart != null) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(descPart.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            description = sb.toString();
        }

        // 📸 處理圖片檔案上傳
        Part filePart = request.getPart("Image");
        if (filePart != null && filePart.getSize() > 0) {
            // 取得上傳的原始檔名
            String contentHeader = filePart.getHeader("content-disposition");
            String originalFileName = null;
            String[] subHeaders = contentHeader.split(";");
            for (String currentHeader : subHeaders) {
                if (currentHeader.trim().startsWith("filename")) {
                    originalFileName = currentHeader.substring(currentHeader.indexOf('=') + 1).trim().replace("\"", "");
                }
            }

            if (originalFileName != null && !originalFileName.trim().isEmpty()) {
                // 取得副檔名 (例如 .jpg)
                String fileExt = originalFileName.substring(originalFileName.lastIndexOf("."));
                // 使用 UUID 生成唯一檔名，防止重名覆蓋
                savedFileName = UUID.randomUUID().toString() + fileExt;

                // 決定儲存路徑：儲存到網域根目錄下的 image/flower 資料夾中
                String savePath = request.getServletContext().getRealPath("image/flower");
                File fileSaveDir = new File(savePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdir(); // 自動建立 images 資料夾
                }

                // 寫入硬碟
                filePart.write(savePath + File.separator + savedFileName);
            }
        }

    } catch (Exception e) {
        out.println("<script>alert('解析表單失敗：" + e.getMessage() + "'); history.back();</script>");
        return;
    }

    // 驗證必要欄位
    if (productName == null || productName.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
        out.println("<script>alert('請至少填寫商品名稱和價格！'); history.back();</script>");
        return;
    }

    // 寫入 MySQL 資料庫
    try {
        if (con == null) {
            out.println("<script>alert('資料庫連線失敗！'); history.back();</script>");
            return;
        }

        String sql = "INSERT INTO product (ProductName, Category, Price, Quantity, Series, Size, Material, AppreciationPeriod, SaveMethods, Language, Idea, Image) " +
                     "VALUES (?, ?, ?, 99, 'For Lover', '約 28x24 公分', '玫瑰、尤加利葉', '鮮花保存約5~7天', '避免陽光直射、避免潮濕環境', '中文', ?, ?)";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productName.trim());
        pstmt.setString(2, category != null ? category.trim() : "fresh");
        pstmt.setInt(3, Integer.parseInt(priceStr.trim()));
        pstmt.setString(4, description != null ? description.trim() : "");
        pstmt.setString(5, savedFileName); // 存入全新生成的圖片檔名

        pstmt.executeUpdate();
        pstmt.close();

        out.println("<script>alert('✅ 商品上架與圖片上傳成功！'); window.location.href='../index.jsp';</script>");
    } catch(Exception e) {
        out.println("<script>alert('資料庫寫入失敗：" + e.getMessage() + "'); history.back();</script>");
    }
%>