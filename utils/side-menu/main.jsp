<%@ page contentType = "text/javascript;charset=utf-8" language = "java" %>

const menuTrigger = document.getElementById('menu-trigger');
const sideMenu = document.getElementById('side-menu');
const closeMenuBtn = document.getElementById('close-menu-btn'); // 新增
const overlay = document.getElementById('menu-overlay');
const sideSearch = document.getElementById('side-search');

// 開啟選單
if (menuTrigger && sideMenu && overlay) {
    menuTrigger.addEventListener('click', (e) => {
        e.stopPropagation();
        if (sideSearch) sideSearch.classList.remove('active');
        sideMenu.classList.add('active'); // 改用 add 確保狀態一致
        overlay.classList.add('active');
    });
}

// [新增] 關閉選單按鈕功能
if (closeMenuBtn) {
    closeMenuBtn.addEventListener('click', () => {
        sideMenu.classList.remove('active');
        overlay.classList.remove('active');
    });
}

// 點擊遮罩關閉
if (overlay) {
    overlay.addEventListener('click', () => {
        if (sideMenu) sideMenu.classList.remove('active');
        if (sideSearch) sideSearch.classList.remove('active');
        overlay.classList.remove('active');
    });
}