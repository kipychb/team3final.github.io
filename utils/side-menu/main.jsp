<%@ page contentType = "text/javascript;charset=utf-8" language = "java" %>

// 搜尋面板開關
const searchTrigger = document.getElementById('search-trigger');
if (searchTrigger) {
    searchTrigger.addEventListener('click', (e) => {
        e.stopPropagation();
        const panel = document.getElementById('side-search');
        const ov = document.getElementById('menu-overlay');
        if (panel) {
            panel.classList.toggle('active');
            if (ov) ov.classList.toggle('active', panel.classList.contains('active'));
            const input = document.getElementById('searchInput');
            if (panel.classList.contains('active') && input) input.focus();
        }
    });
}

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

// 點擊搜尋面板外部關閉搜尋
document.addEventListener('click', (e) => {

    const panel = document.getElementById('side-search');
    const trigger = document.getElementById('search-trigger');

    if (!panel) return;

    if (
        panel.classList.contains('active') &&
        !panel.contains(e.target) &&
        (!trigger || !trigger.contains(e.target))
    ) {
        panel.classList.remove('active');

        if (overlay) {
            overlay.classList.remove('active');
        }
    }
});