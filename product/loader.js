/**
 * 產品頁面自動載入器 - 修正版
*/

// 1. 全域變數統一宣告
let userScore = 0;

async function loadProductDetail() {
    const urlParams = new URLSearchParams(window.location.search);
    const flowerId = urlParams.get('id');

    if (!flowerId) {
        console.error("未找到產品 ID");
        return;
    }

    try {
        const response = await fetch('../flowerData.json');
        const flowerData = await response.json();
        const flower = flowerData.find(f => f.id === flowerId);

        if (flower) {
            document.title = `${flower.name} | 花予祝願所`;
            updateTextContent(flower);
            initImageCarousel(flower);
        } else {
            console.error("找不到該花朵資料");
        }
    } catch (error) {
        console.error("載入產品失敗:", error);
    }
}

// --- 評分系統互動邏輯 ---
function initStarRating() {
    const stars = document.querySelectorAll('.star-rating-input i');
    stars.forEach(star => {
        star.addEventListener('click', function () {
            userScore = parseInt(this.getAttribute('data-value'));
            
            // 修正：點擊時讓目前分度以下的星星都亮起
            stars.forEach(s => {
                const val = parseInt(s.getAttribute('data-value'));
                if (val <= userScore) {
                    s.classList.add('selected');
                } else {
                    s.classList.remove('selected');
                }
            });
            console.log("用戶評分：", userScore);
        });
    });
}

function submitReview() {
    const comment = document.getElementById('comment-input').value;
    if (userScore === 0) {
        alert("請先點選星等評分 ✿");
        return;
    }
    alert(`感謝您的評論！\n評分：${userScore} 顆星\n內容：${comment || '無'}`);
    
    // 清空
    document.getElementById('comment-input').value = "";
    document.querySelectorAll('.star-rating-input i').forEach(s => s.classList.remove('selected'));
    userScore = 0;
}

// --- 更新文字內容 ---
function updateTextContent(flower) {
    let container = document.querySelector('.product-info .info-group');
    if (container) {
        container.querySelector('.name').textContent = flower.name;
        container.querySelector('.series').textContent = "【" + flower.series + "系列】";
        container.querySelector('.price').textContent = "$" + flower.price;
        const descEl = container.querySelector('.desc');
        if (descEl) {
            descEl.style.whiteSpace = "pre-line";
            descEl.textContent = "🕊️花語：" + flower.language + "\n🕊️商品理念：" + flower.idea;
        }
    }

    const invenEl = document.querySelector('.inventory');
    if (invenEl) invenEl.textContent = "僅剩 " + flower.inventory + " 束";

    // 細節與配送須知
    const leftBox = document.querySelector('.left-box');
    const rightBox = document.querySelector('.right-box');

    let appreciationPeriod = flower.is_fresh ? "鮮花保存約 5～7 天" : "良好保存 1 年以上";
    let methods = flower.is_fresh ? [
        "<strong>訂購須知：</strong><br>鮮花受環境影響大，不建議長途配送。",
        "<strong>避光避熱：</strong><br>應放置於通風涼爽處。",
        "<strong>水分照護：</strong><br>需避開花瓣以避免水傷。"
    ] : [
        "<strong>訂購須知：</strong><br>適合遠距離寄送。",
        "<strong>環境控制：</strong><br>務必避免潮濕，防止大力碰撞。"
    ];

    if (leftBox) {
        leftBox.innerHTML = `
            <div><h3>▪️尺寸規格：</h3><p>${flower.size}</p></div>
            <div><h3>▪️使用花材：</h3><p>${flower.material}</p></div>
            <div><h3>▪️鑑賞期：</h3><p>${appreciationPeriod}</p></div>
        `;
    }
    if (rightBox) {
        const methodsHtml = methods.map(m => `<li>${m}</li>`).join('');
        rightBox.innerHTML = `<h3>▪️配送與訂購建議：</h3><ul>${methodsHtml}</ul>`;
    }

    // 綁定購物車按鈕
    const productAddBtn = document.querySelector('.add-cart-btn'); 
    if (productAddBtn) {
        productAddBtn.onclick = function() {
            if (typeof addToCart === "function") {
                // 修正：確保價格轉為字串，相容 shoppingCart.js 的 replace 邏輯
                addToCart(flower.name, flower.price.toString());
            }
        };
    }
}

function initImageCarousel(flower) {
    const imgBox = document.querySelector('.main-img-box');
    if (!imgBox) return;

    const images = imgBox.querySelectorAll('img');
    const dots = imgBox.querySelectorAll('.img-dots span');

    images.forEach((img, index) => {
        // 修正：請確認資料夾名稱是 image 還是 images
        img.src = `../images/flower/${flower.image_path}-${index + 1}.jpg`;
        img.style.display = (index === 0) ? 'block' : 'none';
    });

    dots.forEach((dot, index) => {
        dot.onclick = () => {
            images.forEach((img, i) => img.style.display = (i === index) ? 'block' : 'none');
            dots.forEach(d => d.classList.remove('active'));
            dot.classList.add('active');
        };
    });
}

// 初始化
window.onload = () => {
    loadProductDetail();
    initStarRating();
};