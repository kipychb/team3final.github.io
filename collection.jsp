<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*, java.util.*" %>
<%@ include file="utils/config.jsp" %>
<%
    // 取得由 index.jsp 傳入的 category 參數 (fresh 或 dried)
    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) {
        category = "fresh";
    }

    List<Map<String, Object>> productsList = new ArrayList<>();
    
    // 優先從 request 屬性獲取連線，若無則使用 config.jsp 宣告的 con
    Connection dbCon = (Connection) request.getAttribute("con");
    if (dbCon == null) {
        dbCon = con;
    }

    if (dbCon != null) {
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = dbCon.createStatement();
            // 查詢當前分類之所有商品
            rs = stmt.executeQuery("SELECT * FROM `product` WHERE Category = '" + category + "'");
            
            List<Map<String, Object>> rawList = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("ProductID", rs.getString("ProductID"));
                item.put("ProductName", rs.getString("ProductName"));
                item.put("Series", rs.getString("Series"));
                item.put("Price", rs.getDouble("Price"));
                item.put("Image", rs.getString("Image"));
                rawList.add(item);
            }

            // 實作 12 筆隨機篩選推薦
            Collections.shuffle(rawList);
            int limit = Math.min(rawList.size(), 12);
            int count = 0;

            for (int i = 0; i < limit; i++) {
                Map<String, Object> flower = rawList.get(i);
                count++;

                String image = (String) flower.get("Image");
                String imagePath;
                if (image != null && !image.trim().isEmpty()) {
                    String img = image.trim();
                    if (img.matches("\\d+-1\\.jpg")) {
                        imagePath = "image/flower/" + img.replace("-1.jpg", "-2.jpg");
                    } else {
                        imagePath = "image/flower/" + img;
                    }
                } else {
                    imagePath = "image/default.jpg";
                }
                flower.put("imagePath", imagePath);
                productsList.add(flower);
            }
        } catch (Exception e) {
            out.println("<!-- 商品查詢出錯: " + e.getMessage() + " -->");
        } finally {
            // 釋放資源以防資料庫鎖定
            if (rs != null) try { rs.close(); } catch(Exception e){}
            if (stmt != null) try { stmt.close(); } catch(Exception e){}
        }
    }
%>

<style>
    /* 控制第二頁的商品預設隱藏，不影響版面佈局 */
    .page-hidden {
        display: none !important;
    }
</style>

<%
    // 開始渲染輸出商品 HTML 
    int itemIndex = 0;
    for (Map<String, Object> flower : productsList) {
        itemIndex++;
        int pageNum = (itemIndex <= 6) ? 1 : 2;
        String displayClass = (pageNum == 1) ? "page-active" : "page-hidden";
%>
    <div class="item <%= displayClass %>" data-page="<%= pageNum %>">
        <div class="img-box">
            <a href="product/index.jsp?id=<%= flower.get("ProductID") %>">
                <img src="<%= flower.get("imagePath") %>" alt="<%= flower.get("ProductName") %>" onerror="this.src=''">
            </a>
        </div>
        <div class="item-info">
            <div class="info-top">
                <span class="tag"><%= flower.get("ProductName") %><br>[<%= flower.get("Series") %>]</span>
                <div class="item-actions">
                    <button class="action-btn-circle heart-btn" data-id="<%= flower.get("ProductID") %>">
                        <i class="fa-regular fa-heart"></i>
                    </button>
                    <button class="add-btn-circle" onclick="handleAddToCart(event, <%= flower.get("ProductID") %>)">
                        <i class="fa-solid fa-plus"></i>
                    </button>
                </div>
            </div>
            <span class="price">NT$ <%= java.text.NumberFormat.getNumberInstance().format(flower.get("Price")) %></span>
        </div>
    </div>
<%
    }
%>

<script>
    // 確保只在頁面載入一次控制腳本，防止雙重載入衝突
    if (typeof window.collectionPaginationLoaded === 'undefined') {
        window.collectionPaginationLoaded = true;

        document.addEventListener('DOMContentLoaded', function () {
            setupCollectionPagination();
            syncWishlistStatus();
        });

        // 願望清單即時連動著色
        function syncWishlistStatus() {
            fetch('utils/wishlist/check_wishlist.jsp')
                .then(res => res.json())
                .then(wishlistIds => {
                    const dbWishlist = wishlistIds.map(Number);
                    document.querySelectorAll('.heart-btn').forEach(btn => {
                        const id = Number(btn.getAttribute('data-id'));
                        if (dbWishlist.includes(id)) {
                            const icon = btn.querySelector('.fa-heart');
                            if (icon) {
                                icon.classList.remove('fa-regular');
                                icon.classList.add('fa-solid');
                                icon.style.color = '#c0a080';
                            }
                        }
                    });
                    if (typeof updateHeartIconsStatus === 'function') {
                        updateHeartIconsStatus();
                    }
                })
                .catch(err => console.error("願望清單狀態同步失敗:", err));
        }

        // 左右箭頭與頁碼分頁切換
        function setupCollectionPagination() {
            const collections = document.querySelectorAll('.collection');

            collections.forEach(section => {
                const grid = section.querySelector('.grid-3x2, .grid-2x3');
                if (!grid) return;

                const pageNums = section.querySelectorAll('.page-num');
                const prevBtn = section.querySelector('.fa-chevron-left');
                const nextBtn = section.querySelector('.fa-chevron-right');

                let currentPage = 1;
                const totalPages = 2; // 固定為 12 筆（每頁 6 筆共 2 頁）

                const update = (p) => {
                    if (p < 1 || p > totalPages) return;
                    currentPage = p;

                    pageNums.forEach((n, i) => {
                        if (i + 1 === p) n.classList.add('active');
                        else n.classList.remove('active');
                    });

                    // 執行原本的淡出動畫
                    grid.classList.add('fade-out');

                    setTimeout(() => {
                        const items = grid.querySelectorAll('.item');
                        items.forEach(item => {
                            const itemPage = parseInt(item.getAttribute('data-page'));
                            if (itemPage === p) {
                                item.classList.remove('page-hidden');
                                item.classList.add('page-active');
                            } else {
                                item.classList.remove('page-active');
                                item.classList.add('page-hidden');
                            }
                        });
                        grid.classList.remove('fade-out');
                    }, 300);
                };

                pageNums.forEach((btn, i) => {
                    btn.onclick = () => update(i + 1);
                });

                if (prevBtn) prevBtn.onclick = () => update(currentPage - 1);
                if (nextBtn) nextBtn.onclick = () => update(currentPage + 1);
            });
        }
    }

    // 會員專區跳轉控制
    async function handleMemberClick() {
        try {
            const response = await fetch("utils/auth/check_session.jsp");
            const loginStatus = await response.text();

            if (loginStatus.trim() === 'true') {
                window.location.href = "member/index.jsp";
            } else {
                window.location.href = "member/login/index.jsp";
            }
        } catch (error) {
            console.error("檢查登入狀態失敗:", error);
            window.location.href = "member/login/index.jsp";
        }
    }
</script>