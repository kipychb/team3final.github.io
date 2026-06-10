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