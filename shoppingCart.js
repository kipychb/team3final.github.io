        //購物車
        let cart = [];

        function toggleCart() {
            const sidebar = document.getElementById('cartSidebar');
            const overlay = document.getElementById('cartOverlay');
            if (sidebar) sidebar.classList.toggle('active');
            if (overlay) overlay.style.display = sidebar.classList.contains('active') ? 'block' : 'none';
        }


        document.querySelectorAll('.fa-plus').forEach((btn) => {
            btn.addEventListener('click', function () {
                const itemInfo = this.closest('.item-info');
                const name = itemInfo.querySelector('.tag').innerText;
                const priceTxt = itemInfo.querySelector('.price').innerText;

                const price = parseInt(priceTxt.replace(/[^0-9]/g, '')) || 0;

                cart.push({ id: Date.now(), name: name, price: price });
                updateCartUI();

                this.style.transform = "scale(1.4)";
                setTimeout(() => this.style.transform = "scale(1)", 200);
            });
        });

        function updateCartUI() {
            const list = document.getElementById('cartItems');
            const totalSpan = document.getElementById('cartTotal');
            list.innerHTML = '';
            let total = 0;

            if (cart.length === 0) {
                list.innerHTML = '<p class="empty-msg">購物車是空的</p>';
            } else {
                cart.forEach((item, index) => {
                    total += item.price;
                    list.innerHTML += `
                        <div style="display:flex; justify-content:space-between; margin-bottom:15px; font-size:0.9rem; border-bottom:1px solid #ddd; padding-bottom:5px;">
                            <span>${item.name}</span>
                            <span>NT$ ${item.price} <i class="fa-solid fa-trash" style="margin-left:10px; cursor:pointer;" onclick="removeItem(${index})"></i></span>
                        </div>`;
                });
            }
            totalSpan.innerText = total.toLocaleString();
        }

        function removeItem(index) {
            cart.splice(index, 1);
            updateCartUI();
        }


        const revealElements = document.querySelectorAll('.collection, .quiz-intro, .contact-top');
        revealElements.forEach(el => {
            el.style.opacity = "0";
            el.style.transform = "translateY(30px)";
            el.style.transition = "all 0.8s ease-out";
        });

        window.addEventListener('scroll', () => {
            revealElements.forEach(el => {
                const windowHeight = window.innerHeight;
                const revealTop = el.getBoundingClientRect().top;
                if (revealTop < windowHeight - 100) {
                    el.style.opacity = "1";
                    el.style.transform = "translateY(0)";
                }
            });
        });