/**
 * 側邊選單控制 (Menu Panel)
 */

const menuTrigger = document.getElementById('menu-trigger');
const sideMenu = document.getElementById('side-menu');
const sideSearch = document.getElementById('side-search');
const overlay = document.getElementById('menu-overlay');

if (menuTrigger && sideMenu && overlay) {
    menuTrigger.addEventListener('click', (e) => {
        e.stopPropagation();

        // 關閉搜尋面板
        if (sideSearch) sideSearch.classList.remove('active');

        sideMenu.classList.toggle('active');
        overlay.classList.toggle('active');
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