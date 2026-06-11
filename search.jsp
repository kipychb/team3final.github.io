<%@page contentType="text/javascript;charset=utf-8" language="java" import="java.sql.*, java.util.*" %>
<%@include file="utils/config.jsp" %>
<%
    // 優先從 request 屬性獲取連線，若無則使用 config.jsp 宣告的 con
    Connection dbCon = (Connection) request.getAttribute("con");
    if (dbCon == null) {
        dbCon = con;
    }

    StringBuilder jsonBuilder = new StringBuilder();
    jsonBuilder.append("[");

    if (dbCon != null) {
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = dbCon.createStatement();
            // 查詢所有商品需要的搜尋欄位
            rs = stmt.executeQuery("SELECT ProductID, ProductName, Language, Idea, Material, Series FROM `product`");
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonBuilder.append(",");
                }
                first = false;

                String id = rs.getString("ProductID");
                String name = rs.getString("ProductName");
                String language = rs.getString("Language");
                String idea = rs.getString("Idea");
                String material = rs.getString("Material");
                String series = rs.getString("Series");

                // 防呆並過濾掉會破壞 JSON 格式的特殊字元
                name = (name == null) ? "" : name.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                language = (language == null) ? "" : language.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                idea = (idea == null) ? "" : idea.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                material = (material == null) ? "" : material.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                series = (series == null) ? "" : series.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");

                jsonBuilder.append("{")
                           .append("\"ProductID\":\"").append(id).append("\",")
                           .append("\"ProductName\":\"").append(name).append("\",")
                           .append("\"Language\":\"").append(language).append("\",")
                           .append("\"Idea\":\"").append(idea).append("\",")
                           .append("\"Material\":\"").append(material).append("\",")
                           .append("\"Series\":\"").append(series).append("\"")
                           .append("}");
            }
        } catch (Exception e) {
            out.println("// 資料庫讀取失敗: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e){}
            if (stmt != null) try { stmt.close(); } catch(Exception e){}
        }
    }
    jsonBuilder.append("]");
%>

/*
 * search.jsp
 * 搜尋欄控制 (Search Panel) - 伺服器端 SSR 方案
 */

// 由 JSP 直接注入所有商品資料，免除前端 Fetch 網路延遲
let flowerData = <%= jsonBuilder.toString() %>;
let hrefPrefix = "";

// 2. 顯示推薦與熱門搜尋
function showRecommendations() {
    const suggestionsList = document.getElementById('search-suggestions');
    const searchInput = document.getElementById('searchInput');
    if (!suggestionsList) return;

    const hotKeywords = ["青春", "向日葵", "朋友"];
    suggestionsList.innerHTML = "";

    const hotTitle = document.createElement('li');
    hotTitle.textContent = "近期熱搜：";
    hotTitle.style.cssText = "font-size: 0.9rem; color: #a3a69c; border: none; margin-top: 10px; cursor: default;";
    suggestionsList.appendChild(hotTitle);

    hotKeywords.forEach(keyword => {
        const li = document.createElement('li');
        li.textContent = keyword;
        li.style.color = "#705844";
        li.onclick = (e) => {
            e.stopPropagation();
            searchInput.value = keyword;
            searchInput.dispatchEvent(new Event('input'));
        };
        suggestionsList.appendChild(li);
    });

    const recTitle = document.createElement('li');
    recTitle.textContent = "推薦商品：";
    recTitle.style.cssText = "font-size: 0.9rem; color: #a3a69c; border: none; margin-top: 20px; cursor: default;";
    suggestionsList.appendChild(recTitle);

    if (flowerData.length > 0) {
        const shuffled = [...flowerData].sort(() => 0.5 - Math.random());
        shuffled.slice(0, 5).forEach(flower => {
            const li = document.createElement('li');
            li.textContent = flower.ProductName;
            li.onclick = () => window.location.href = hrefPrefix + "product/index.jsp?id=" + flower.ProductID;
            suggestionsList.appendChild(li);
        });
    }
}

// 初始化綁定
document.addEventListener('DOMContentLoaded', () => {
    // 由於商品資料已在伺服器端載入完畢，這裡直接執行事件綁定

    const searchTrigger = document.getElementById('search-trigger');
    const sideSearch = document.getElementById('side-search');
    const searchInput = document.getElementById('searchInput');
    const overlay = document.querySelector('.overlay');

    // 1. 開關面板邏輯
    if (searchTrigger) {
        searchTrigger.addEventListener('click', (e) => {
            e.stopPropagation();
            sideSearch.classList.toggle('active');
            if (overlay) overlay.classList.toggle('active');

            if (sideSearch.classList.contains('active')) {
                searchInput.focus();
                if (searchInput.value.trim() === "") showRecommendations();
            }
        });
    }

    // 2. 全域點擊監聽 (點擊外部自動關閉)
    document.addEventListener('click', (e) => {
        if (sideSearch && sideSearch.classList.contains('active')) {
            // 如果點擊目標不是搜尋框也不是按鈕，就關閉
            if (!sideSearch.contains(e.target) && e.target !== searchTrigger) {
                sideSearch.classList.remove('active');
                if (overlay) overlay.classList.remove('active');
            }
        }
    });

    // 3. 即時搜尋邏輯
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const query = this.value.trim().toLowerCase();
            const suggestionsList = document.getElementById('search-suggestions');
            suggestionsList.innerHTML = "";

            if (query.length > 0) {
                const filtered = flowerData.filter(f => {
                    const name = (f.ProductName || "").toLowerCase();
                    const language = (f.Language || "").toLowerCase();
                    const idea = (f.Idea || "").toLowerCase();
                    const material = (f.Material || "").toLowerCase();
                    const series = (f.Series || "").toLowerCase();

                    return (
                        name.includes(query) ||
                        language.includes(query) ||
                        idea.includes(query) ||
                        material.includes(query) ||
                        series.includes(query)
                    );
                });

                if (filtered.length > 0) {
                    filtered.forEach(f => {
                        const li = document.createElement('li');
                        li.textContent = f.ProductName;
                        li.onclick = () => window.location.href = hrefPrefix + "product/index.jsp?id=" + f.ProductID;
                        suggestionsList.appendChild(li);
                    });
                } else {
                    suggestionsList.innerHTML = "<li style='cursor: default; padding:10px;'>找不到符合的商品</li>";
                }
            } else {
                showRecommendations();
            }
        });
    }
});