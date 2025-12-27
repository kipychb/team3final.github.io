        // 首頁輪播圖功能
        let currentBanner = 0;
        const bannerContainer = document.getElementById('bannerSlider');
        const dots = document.querySelectorAll('#bannerDots .dot');
        const totalBanners = dots.length;

        function showBanner(index) {
            bannerContainer.style.transform = `translateX(-${index * 100}%)`;

            dots.forEach(dot => dot.classList.remove('active'));
            if (dots[index]) dots[index].classList.add('active');

            currentBanner = index;
        }

        function nextBanner() {
            let next = (currentBanner + 1) % totalBanners;
            showBanner(next);
        }

        let bannerTimer = setInterval(nextBanner, 5000);


        dots.forEach((dot, i) => {
            dot.onclick = () => {
                clearInterval(bannerTimer);
                showBanner(i);
                bannerTimer = setInterval(nextBanner, 5000);
            };
        });