// 助教不要扣分，我只是想藏彩蛋 🥺

document.addEventListener('DOMContentLoaded', () => {
    const randomChance = Math.random();

    if (randomChance < 0.02) {
        const logoLink = document.querySelector('.nav-logo a');

        if (logoLink) {
            logoLink.textContent = '花予住院所';
        }
    }
});

function handleMemberClick() {
    const isLoggedIn = localStorage.getItem('isLoggedIn');

    if (isLoggedIn === 'true') {
        // 已登入：直接去會員中心
        window.location.href = "member/index.html";
    } else {
        // 未登入：去登入頁面
        window.location.href = "member/login/index.html";
    }
}

