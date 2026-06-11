<%@ page contentType="text/html;charset=utf-8" language="java" import="java.sql.*, java.util.*" %>
<%
    // 💡 採用純 Header 判定方式，徹底避免 javax/jakarta.servlet.http.Cookie 導包在不同 Tomcat 版本發生的編譯錯誤
    boolean showBanner = true;
    try {
        String cookieHeader = request.getHeader("Cookie");
        if (cookieHeader != null && cookieHeader.contains("cookieConsent=")) {
            // 如果請求的 Cookie Header 中已經包含 cookieConsent 欄位，代表用戶已做過選擇，伺服器端直接不輸出橫幅 HTML
            showBanner = false;
        }
    } catch (Exception e) {
        // 發生任何意外時預設顯示，防止頁面崩潰
        showBanner = true;
    }

    if (showBanner) {
%>
    <!-- Cookie 同意橫幅 HTML 結構 -->
    <div id="cookie-banner"
        style="position:fixed; bottom:0; left:0; width:100%; background:linear-gradient(135deg, #333, #444); color:white; padding:18px 20px; text-align:center; z-index:9999; box-shadow:0 -4px 15px rgba(0,0,0,0.3); font-family:Arial, sans-serif;">
        <div style="max-width:1100px; margin:0 auto; display:flex; align-items:center; justify-content:center; flex-wrap:wrap; gap:15px;">
            <span>
                本網站使用 Cookie 來提升您的使用體驗與購物功能，繼續瀏覽即表示您同意我們的
                <a href="privacy.jsp" style="color:#705844; text-decoration:underline;">隱私權政策</a>。
            </span>

            <div>
                <button onclick="acceptCookie()"
                    style="padding:10px 22px; margin:0 8px; background:#705844; color:white; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">
                    我同意
                </button>
                <button onclick="rejectCookie()"
                    style="padding:10px 22px; margin:0 8px; background:#666; color:white; border:none; border-radius:6px; cursor:pointer;">
                    拒絕
                </button>
            </div>
        </div>
    </div>

    <!-- 專屬控制腳本 -->
    <script>
        // 設定 Cookie 的輔助函式（保存 365 天）
        function setCookie(name, value, days) {
            let expires = "";
            if (days) {
                let date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "")  + expires + "; path=/; SameSite=Lax";
        }

        function acceptCookie() {
            // 1. 同步寫入 localStorage 保持原前端邏輯相容
            localStorage.setItem('cookieConsent', 'true');
            // 2. 寫入 Cookie 供 JSP 伺服器端判斷
            setCookie('cookieConsent', 'true', 365);
            
            document.getElementById('cookie-banner').style.display = 'none';
        }

        function rejectCookie() {
            // 1. 同步寫入 localStorage 保持原前端邏輯相容
            localStorage.setItem('cookieConsent', 'false');
            // 2. 寫入 Cookie 供 JSP 伺服器端判斷
            setCookie('cookieConsent', 'false', 365);
            
            document.getElementById('cookie-banner').style.display = 'none';
        }

        // 雙重安全防護：如果客戶端 localStorage 已經有紀錄，但伺服器端 Cookie 剛好過期，則直接隱藏
        document.addEventListener('DOMContentLoaded', function () {
            if (localStorage.getItem('cookieConsent')) {
                const banner = document.getElementById('cookie-banner');
                if (banner) {
                    banner.style.display = 'none';
                }
                // 順便補寫回 Cookie 確保同步
                setCookie('cookieConsent', localStorage.getItem('cookieConsent'), 365);
            } else {
                const banner = document.getElementById('cookie-banner');
                if (banner) {
                    banner.style.display = 'block';
                }
            }
        });
    </script>
<%
    }
%>