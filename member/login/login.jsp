<%@ page contentType="text/javascript;charset=utf-8" language="java" %>
<%
    // 💡 核心升級：在伺服器端直接讀取當前 Session 中的 mid 屬性
    Object midObj = session.getAttribute("mid");
    boolean isLoggedIn = (midObj != null);
%>

// member/login/login.jsp
/**
 * 功能：會員登入控制與登入狀態檢查
 * 說明：已重構為 JSP 驅動版，採用 Session 屬性 mid 作為判斷依據，取代 localStorage 舊機制
 */

// 將伺服器端 Session 狀態直接注入前端 JS 全域變數
const serverIsLoggedIn = <%= isLoggedIn %>;

function loginSubmit() {
    const accEl = document.getElementById('account');
    const passEl = document.getElementById('password');

    // 抓取使用者「當下」輸入的文字
    const currentName = accEl.value.trim();
    const currentPass = passEl.value.trim();

    if (currentName === "" || currentPass === "") {
        alert("請填寫帳號與密碼!");
        return;
    }

    // 💡 核心變更：不再透過 localStorage 模擬登入，而是將資料送往後端 do_login.jsp 進行認證並寫入 Session
    fetch('do_login.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `account=\${encodeURIComponent(currentName)}&password=\${encodeURIComponent(currentPass)}`
    })
    .then(res => res.text())
    .then(result => {
        const res = result.trim();
        if (res === 'success') {
            alert(currentName + "，花予祝願所歡迎您的歸來 ✿");
            
            // 登入成功後，清除舊版 localStorage 的殘留標記以確保一致性
            localStorage.removeItem('isLoggedIn');
            localStorage.removeItem('member-name');

            setTimeout(() => {
                // 自動導回 JSP 版本首頁
                window.location.href = "../../index.jsp";
            }, 1200);
        } else {
            alert("登入失敗：請檢查您的帳號與密碼是否正確！");
        }
    })
    .catch(err => {
        console.error("登入請求失敗:", err);
        alert("網路連線異常，請檢查主機連線狀態。✿");
    });
}

function handleMemberClick() {
    // 💡 優先讀取伺服器端注入的 Session 狀態
    const isLoggedIn = serverIsLoggedIn;

    // 動態計算根目錄，防止在不同資料夾層級（如 product、member、payment 等）點擊時跳轉錯誤
    const path = window.location.pathname;
    let rootLayer = "./";
    
    if (path.includes('/product/') || path.includes('/series/') || path.includes('/member/') || path.includes('/utils/') || path.includes('/payment/')) {
        rootLayer = "../";
    }
    // 若在 /member/login/ 內則需要退兩層
    if (path.includes('/member/login/')) {
        rootLayer = "../../";
    }

    if (isLoggedIn) {
        // 已登入：直接去會員中心 JSP
        window.location.href = rootLayer + "member/index.jsp";
    } else {
        // 未登入：去登入頁面 JSP
        window.location.href = rootLayer + "member/login/index.jsp";
    }
}